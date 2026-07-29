# Comment déployer sa documentation MkDocs sur GitHub Pages avec GitHub Actions

Ce guide détaille la mise en place du workflow de déploiement automatique Snore-Stack via **GitHub Actions** et **Docker**.

Plutôt que d'installer Python et des paquets pip à chaque build, nous utilisons l'image Docker officielle `squidfunk/mkdocs-material` pour garantir un rendu 100% identique au développement local.

---

## 📋 Prérequis

1. Avoir activé **GitHub Actions** comme source de déploiement dans GitHub (*Settings > Pages > Source : GitHub Actions*).
2. Avoir le fichier `.github/workflows/deploy.yml` à la racine de votre dépôt.

---

## 📄 Le Fichier de Workflow Expliqué Ligne par Ligne

Voici le contenu exact du fichier `.github/workflows/deploy.yml` utilisé sur le dépôt :

```yaml
name: Deploy MkDocs to GitHub Pages

on:
  push:
    branches:
      - main

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: false

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Build site with MkDocs Material Docker
        run: |
          docker run --rm -v ${{ github.workspace }}:${{ github.workspace }} -w ${{ github.workspace }} squidfunk/mkdocs-material:9 build

      - name: Setup Pages
        uses: actions/configure-pages@v4

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: site

      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

---

## 🔍 Explication Détaillée des Blocs

### 1. Le Déclencheur (`on: push`)
```yaml
on:
  push:
    branches:
      - main
```
* **Pourquoi ?** Le workflow ne se lance que lorsqu'un commit est poussé ou fussionné (*merged*) sur la branche principale `main`. Cela évite de rebâtir le site pour des branches de travail temporaires.

---

### 2. Les Permissions (`permissions`)
```yaml
permissions:
  contents: read
  pages: write
  id-token: write
```
* **`contents: read`** : Autorise le job à lire le code source du dépôt.
* **`pages: write`** : Donne le droit de publier les fichiers HTML compilés sur les serveurs GitHub Pages.
* **`id-token: write`** : Permet l'authentification sécurisée via OpenID Connect (OIDC) sans clé d'API statique.

---

### 3. La Gestion des Concurrences (`concurrency`)
```yaml
concurrency:
  group: pages
  cancel-in-progress: false
```
* **Pourquoi ?** Si deux commits sont faits coup sur coup, ce bloc s'assure qu'un build ne vient pas écraser un autre en plein milieu.
* **`cancel-in-progress: false`** : Attend que le déploiement en cours se termine proprement plutôt que de le couper brutalement.

---

### 4. L'Environnement et le Runner (`jobs: build-and-deploy`)
```yaml
runs-on: ubuntu-latest
environment:
  name: github-pages
  url: ${{ steps.deployment.outputs.page_url }}
```
* **`runs-on: ubuntu-latest`** : Demande à GitHub d'allouer une machine virtuelle Ubuntu fraîche pour exécuter le build.
* **`url: ${{ steps.deployment.outputs.page_url }}`** : Récupère dynamiquement l'URL publique générée à l'étape finale et l'affiche dans l'interface GitHub.

---

### 5. Les Étapes d'Exécution (`steps`)

#### A. Récupération du code (`actions/checkout@v4`)
```yaml
- name: Checkout repository
  uses: actions/checkout@v4
```
* Clône votre code source dans la machine virtuelle du runner.

#### B. Build MkDocs avec Docker (`squidfunk/mkdocs-material:9`)
```yaml
- name: Build site with MkDocs Material Docker
  run: |
    docker run --rm -v ${{ github.workspace }}:${{ github.workspace }} -w ${{ github.workspace }} squidfunk/mkdocs-material:9 build
```
* **Pourquoi Docker ?** Évite d'installer Python et des dépendances pip sur le runner. On utilise directement l'image officielle.
* **`-v ${{ github.workspace }}:${{ github.workspace }}`** : Monte le dossier du code dans le conteneur Docker.
* **`-w ${{ github.workspace }}`** : Définit le répertoire de travail dans le conteneur.
* **`build`** : Exécute la commande MkDocs qui génère le HTML statique dans le dossier `site/`.

#### C. Configuration & Envoi de l'Artefact (`configure-pages` & `upload-pages-artifact`)
```yaml
- name: Setup Pages
  uses: actions/configure-pages@v4
- name: Upload artifact
  uses: actions/upload-pages-artifact@v3
  with:
    path: site
```
* Prépare les métadonnées GitHub Pages et compresse le dossier `site/` généré par MkDocs sous forme d'artefact zip sécurisé.

#### D. Publication finale (`actions/deploy-pages@v4`)
```yaml
- name: Deploy to GitHub Pages
  id: deployment
  uses: actions/deploy-pages@v4
```
* Prend l'artefact zip et le publie en ligne sur les serveurs CDN de GitHub Pages.
