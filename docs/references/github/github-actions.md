# GitHub Actions & Workflows

**GitHub Actions** est la plateforme d'intégration et de déploiement continus (CI/CD) intégrée à GitHub. Elle permet d'automatiser vos pipelines de build, de test et de déploiement directement depuis votre dépôt.

---

## 🏗️ Anatomie d'un Workflow

Un workflow GitHub Actions est un processus automatisé défini dans un fichier **YAML** situé dans le dossier `.github/workflows/` de votre dépôt.

```text
.github/
└── workflows/
    ├── ci.yml
    └── deploy.yml
```

### Les 5 Concepts Clés

```text
[ Événement (on) ] ──► [ Workflow ] ──► [ Job(s) ] ──► [ Step(s) ] ──► [ Action(s) / Shell ]
```

1. **Workflow** : Le processus complet défini dans un fichier `.yml`.
2. **Event (`on`)** : Déclencheur du workflow (ex: `push`, `pull_request`, horaire `schedule`, ou manuel `workflow_dispatch`).
3. **Job** : Ensemble d'étapes exécutées sur un même serveur virtuel (*Runner*). Les jobs s'exécutent en parallèle par défaut.
4. **Step** : Une tâche individuelle au sein d'un job (ex: exécuter une commande bash ou appeler une Action).
5. **Action** : Un composant réutilisable pré-codé (ex: `actions/checkout@v4` pour récupérer le code).

---

## 🏷️ Gestion des Actions et des Versionings (Tags vs Commits)

Dans une étape (`step`), l'instruction `uses` fait appel à une Action réutilisable disponible sur la **GitHub Marketplace**.

Exemple : `uses: actions/checkout@v4`

### Comment fonctionne le versioning des Actions ?

Il existe 3 façons de spécifier la version d'une Action :

| Syntaxe | Stabilité / Sécurité | Recommandation |
| :--- | :--- | :--- |
| **`actions/checkout@v4`** *(Tag Majeur)* | **Excellente ergonomie**. Vous bénéficiez automatiquement des correctifs mineurs et de sécurité de la version 4 sans casser le workflow. | **Recommandé au quotidien** |
| **`actions/checkout@v4.1.2`** *(Tag Exact)* | Fixe une version ultra-précise. Évite tout changement inattendu mais nécessite des mises à jour manuelles. | Utile pour des environnements critiques |
| **`actions/checkout@b4ffde...`** *(Commit SHA)* | **Sécurité maximale**. Protège contre les attaques de type *Supply Chain* (si le compte du créateur de l'action est piraté et le tag déplacé). | Recommandé en entreprise / haute sécurité |

---

## 🔍 Comment trouver et choisir de bonnes Actions ?

Lorsque vous cherchez à automatiser une tâche (ex: linter du code, envoyer un message Slack, builder une image Docker) :

1. **La GitHub Marketplace** ([github.com/marketplace/actions](https://github.com/marketplace/actions)) : C'est le catalogue officiel.
2. **Prioriser les Éditeurs Vérifiés** :
   * Privilégier les actions créées par **`actions/`** (l'équipe officielle GitHub, ex: `actions/checkout`, `actions/setup-python`).
   * Privilégier les créateurs officiels de la techno (ex: `docker/build-push-action` par Docker, `squidfunk/mkdocs-material` par MkDocs Material).
3. **Vérifier les critères de confiance** :
   * Nombre d'étoiles (*Stars*) sur le dépôt.
   * Fréquence des mises à jour récentes.
   * Présence du badge **Verified Creator**.

---

## ⚙️ Les Éléments Syntaxiques d'un fichier YAML

| Mot-clé YAML | Rôle | Exemple |
| :--- | :--- | :--- |
| **`name`** | Nom affiché dans l'onglet Actions de GitHub | `name: Deploy Documentation` |
| **`on`** | Les événements déclencheurs | `on: push: branches: [main]` |
| **`permissions`** | Droits accordés au jeton temporaire `GITHUB_TOKEN` | `permissions: contents: read` |
| **`concurrency`** | Empêche les builds simultanées conflictuelles | `concurrency: group: pages` |
| **`jobs`** | Définition des travaux à exécuter | `jobs: build-and-deploy:` |
| **`runs-on`** | Le système d'exploitation du runner | `runs-on: ubuntu-latest` |
| **`environment`** | Cible un environnement d'hébergement GitHub | `environment: name: github-pages` |
| **`steps`** | La suite d'instructions séquentielle | `steps: - uses: ... - run: ...` |
| **`uses`** | Appelle une action communautaire pré-existante | `uses: actions/checkout@v4` |
| **`run`** | Exécute une commande terminal bash dans le runner | `run: docker run ...` |
| **`with`** | Passe des paramètres d'entrée (*inputs*) à une Action | `with: path: site` |

---

## 🔒 GITHUB_TOKEN & Secrets

GitHub injecte automatiquement un jeton de sécurité temporaire (`secrets.GITHUB_TOKEN`) dans chaque workflow pour lui permettre d'interagir de manière sécurisée avec le dépôt (lire le code, créer des releases, publier sur GitHub Pages) sans stocker de mot de passe.
