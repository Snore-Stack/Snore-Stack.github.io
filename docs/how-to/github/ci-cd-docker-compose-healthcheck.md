# Validation CI/CD avec Docker Compose & Healthcheck (GitHub Actions)

Ce guide décrit le patron de conception pour valider automatiquement la compilation, l'exécution et le **healthcheck HTTP** d'une application conteneurisée via GitHub Actions.

---

## 🎯 Principes & Objectifs

Dans un pipeline d'intégration continue (CI) :
1. On valide que le code compile.
2. On démarre les services en mode détaché (`docker compose up -d`).
3. On vérifie que les endpoints de santé répondent avec succès (`curl`).
4. **Garantie de nettoyage** : On éteint systématiquement les conteneurs (`docker compose down`) via `if: always()`, même en cas d'échec des tests, afin de libérer les ressources du runner virtuel.

---

## 🛠️ Le Workflow GitHub Actions (`.github/workflows/ci.yml`)

```yaml
name: CI / Build & Healthcheck

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  integration-test:
    name: Build & Healthcheck Verification
    runs-on: ubuntu-latest
    permissions:
      contents: read

    steps:
      - name: Checkout du code source
        uses: actions/checkout@v4

      # 1. Injection dynamique des variables .env dans l'environnement du Runner
      - name: Préparation et chargement de l'environnement
        run: |
          cp .env.example .env
          cat .env >> $GITHUB_ENV

      # 2. Étape de compilation / Sanity check
      - name: Build des images Docker
        run: docker compose build

      # 3. Démarrage des services en tâche de fond (Detached Mode)
      - name: Lancement du conteneur
        run: docker compose up -d

      # 4. Test d'intégration et sondage du Healthcheck
      - name: Test de l'endpoint Healthcheck
        run: |
          curl --fail --retry 5 --retry-connrefused --retry-delay 2 http://localhost:${HOST_PORT:-8080}/healthz

      # 5. Nettoyage inconditionnel (Post-exécution)
      - name: Nettoyage et arrêt des conteneurs
        if: always()
        run: docker compose down -v
```

---

## 🔍 Explication des mécanismes clés

### 1. `cat .env >> $GITHUB_ENV`
Sous GitHub Actions, modifier un fichier `.env` sur le disque ne rend pas ses variables disponibles immédiatement dans les étapes de shell du runner. 
Le fichier spécial `$GITHUB_ENV` permet d'exporter dynamiquement chaque clé-valeur afin que `$HOST_PORT` soit utilisable dans les commandes `curl` ultérieures.

### 2. `curl --fail --retry 5 --retry-connrefused`
- **`--fail`** : Renvoie immédiatement un code de sortie d'erreur (`exit 1`) si le serveur répond un statut HTTP 4xx ou 5xx.
- **`--retry 5`** : Retente la requête jusqu'à 5 fois si la connexion est initialement refusée (laissant au conteneur quelques secondes pour finaliser son démarrage).
- **`--retry-delay 2`** : Attends 2 secondes entre chaque tentative.

### 3. `if: always()`
C'est la garantie de sécurité. Si l'étape `curl` échoue, GitHub Actions arrête la progression normale du job. 
Sans `if: always()`, l'étape de nettoyage `docker compose down` serait ignorée, laissant des processus fantômes bloquer la fermeture du runner. `if: always()` agit comme un bloc `finally` universel.
