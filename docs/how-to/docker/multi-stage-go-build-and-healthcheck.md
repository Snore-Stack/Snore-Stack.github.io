# Build Multi-stage Docker pour Go & Healthcheck Docker Compose

Ce guide présente le patron d'architecture (*pattern*) générique pour conteneuriser une application Web en Go de manière sécurisée et ultra-légère, ainsi que la méthode pour surveiller sa santé via Docker Compose.

---

## 📋 Contextualisation & Enjeux

Par défaut, une image Docker basée sur l'image Go officielle (`golang:latest`) pèse environ **800 Mo** à **1 Go**, car elle embarque le compilateur Go complet et tout le SDK.

Le **Multi-stage Build** résout ce problème en séparant le conteneur en deux phases :
1. **Étape de compilation (*Builder*)** : Utilise le SDK Go complet pour compiler un binaire statique.
2. **Étape d'exécution (*Runner*)** : Ne conserve **que le binaire compilé** dans une image minimale (ex: `alpine` ~10 Mo).

---

## 🏗️ 1. Spécification du Dockerfile Multi-stage

```dockerfile
# ==========================================
# Étape 1 : Builder (Environnement de compilation)
# ==========================================
FROM golang:1.24-alpine AS builder

WORKDIR /app

# Optimisation du cache Docker : On télécharge les dépendances en premier
COPY go.mod ./
# COPY go.sum ./
RUN go mod download

# Copie du reste du code source
COPY . .

# Compilation d'un binaire Linux statique (sans dépendances CGO)
RUN CGO_ENABLED=0 GOOS=linux go build -o app-binary main.go

# ==========================================
# Étape 2 : Runner (Environnement d'exécution minimal)
# ==========================================
FROM alpine:latest AS runner

WORKDIR /app

# Dossier optionnel si l'application manipule des fichiers ou une BDD locale (ex: SQLite)
RUN mkdir -p /data

# Copie exclusive du binaire compilé depuis l'étape 'builder'
COPY --from=builder /app/app-binary .

EXPOSE 8080

CMD ["./app-binary"]
```

### 💡 Comprendre les flags de compilation :
- **`CGO_ENABLED=0`** : Désactive `cgo` (l'interfaçage avec les bibliothèques C système). Cela garantit que le binaire produit est **100% autonome et statique**, capable d'exécuter sans `glibc` sur n'importe quel noyau Linux.
- **`GOOS=linux`** : Force la compilation pour le système cible Linux.

---

## 🐳 2. Surveillance de santé (Healthcheck) dans Docker Compose

Un **Healthcheck** permet à l'orchestrateur (Docker Compose, Swarm, Kubernetes) de s'assurer que l'application écoute et répond correctement aux requêtes HTTP, et pas seulement que le processus est en cours d'exécution.

```yaml
name: my-application

services:
  api:
    build:
      context: ./backend
      dockerfile: Dockerfile
      target: runner
    environment:
      - PORT=${APP_PORT:-8080}
    ports:
      - "${HOST_PORT:-8080}:${APP_PORT:-8080}"
    healthcheck:
      test: ["CMD-SHELL", "wget -qO- http://localhost:${APP_PORT:-8080}/healthz || exit 1"]
      interval: 10s
      timeout: 3s
      retries: 3
      start_period: 5s
    restart: unless-stopped
```

---

## 🔍 Analyse de la commande de test

`wget -qO- http://localhost:8080/healthz} || exit 1`

- **`-q`** (*quiet*) : Mode silencieux pour éviter de polluer les journaux du conteneur à chaque vérification.
- **`-O-`** (*Output to stdout*) : Écrit la réponse HTTP vers la sortie standard au lieu de créer un fichier physique sur le disque.
- **`|| exit 1`** : Si la requête HTTP échoue (ex: statut 500, connexion refusée), le sous-shell se termine immédiatement avec le code d'erreur `1` (signalant l'état *unhealthy* à Docker).

### Paramètres d'évaluation :
- **`interval`** : Périodicité du test d'invalidation (toutes les 10 secondes).
- **`timeout`** : Temps limite accordé pour recevoir la réponse HTTP (3 secondes).
- **`retries`** : Nombre d'échecs consécutifs nécessaires avant de passer le statut à `unhealthy` (évite les fausses alertes sur micro-pics).
- **`start_period`** : Période de grâce initiale accordée au conteneur au démarrage.

---

## 🔗 À lire aussi

- 🛡️ **[Sécuriser un Dockerfile & Intégrer Trivy en CI/CD](securing-dockerfile-and-trivy-ci.md)** : Apprendre à exécuter ses conteneurs en mode non-root et auditer la sécurité des images avec Trivy.

