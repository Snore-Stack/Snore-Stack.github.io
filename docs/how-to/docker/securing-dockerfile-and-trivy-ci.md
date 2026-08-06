# Sécuriser un Dockerfile (Non-Root & Healthcheck) & Intégrer Trivy en CI/CD

Ce guide explique comment corriger les erreurs de sécurité courantes d'un `Dockerfile` (exécution en mode non-root et portabilité du healthcheck) et comment automatiser l'analyse de vulnérabilités avec **Trivy** dans un pipeline GitHub Actions.

Pour consulter la liste complète des commandes CLI et règles de sécurité Trivy, référez-vous à la [Fiche de Référence Trivy](../../references/docker/trivy-cli-and-checks.md).

---

## 🛠️ Étape 1 : Corriger le Dockerfile pour le passage en Non-Root & Healthcheck

Dans un Dockerfile multi-stage (ex: Go / Alpine), ajoutez la création d'un utilisateur non-privilégié, attribuez la propriété des fichiers compilés et ajoutez l'instruction `HEALTHCHECK`.

```dockerfile
# ==========================================
# Étape 1 : Builder
# ==========================================
FROM golang:1.24-alpine AS builder
WORKDIR /app
COPY go.mod ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o server main.go

# ==========================================
# Étape 2 : Runner (Sécurisé & Non-Root)
# ==========================================
FROM alpine:latest AS runner
WORKDIR /app

# 1. Création d'un utilisateur non-root dédié (UID 10001)
RUN adduser -D -u 10001 appuser && chown -R appuser:appuser /app

# 2. Copie du binaire en attribuant les droits à l'utilisateur non-root
COPY --from=builder --chown=appuser:appuser /app/server .

EXPOSE 8080

# 3. Bascule vers l'utilisateur non-root (Résout Trivy DS-0002)
USER appuser

# 4. Déclaration du Healthcheck portable (Résout Trivy DS-0026)
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost:8080/healthz || exit 1

CMD ["./server"]
```

---

## 🧪 Étape 2 : Auditer localement avec Trivy CLI

Avant d'envoyer votre code sur le dépôt distant, validez le Dockerfile et l'image compilée localement :

```bash
# 1. Auditer la configuration du Dockerfile
trivy config ./backend/Dockerfile

# 2. Compiler l'image Docker
docker build -t my-app:latest ./backend

# 3. Scanner les vulnérabilités de l'image
trivy image my-app:latest
```

---

## 🚀 Étape 3 : Automatiser l'audit dans GitHub Actions

Pour bloquer les Pull Requests ou les builds introduisant des vulnérabilités critiques, ajoutez l'action officielle `aquasecurity/trivy-action` dans votre workflow (`.github/workflows/build.yml`) :

```yaml
name: Build & Security Audit

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  security-scan:
    name: Build & Trivy Scan
    runs-on: ubuntu-latest
    steps:
      - name: Checkout du code
        uses: actions/checkout@v4

      - name: Build de l'image Docker
        run: docker build -t my-app:${{ github.sha }} ./backend

      - name: Audit de sécurité Trivy
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: 'my-app:${{ github.sha }}'
          format: 'table'
          exit-code: '1' # Fait échouer la CI si des failles High/Critical sont détectées
          ignore-unfixed: true
          severity: 'CRITICAL,HIGH'
```
