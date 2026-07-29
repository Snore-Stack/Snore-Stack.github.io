# Comment enchaîner deux workflows GitHub Actions (workflow_run)

Ce guide explique comment faire en sorte qu'un **workflow B** (ex: *Release automatique avec Semantic Release*) s'exécute **uniquement après la réussite complète** d'un **workflow A** (ex: *Build et Déploiement MkDocs*), sans avoir à tout fusionner dans un seul gros fichier YAML.

---

## 📋 Le Problème

Par défaut dans GitHub Actions, si vous avez deux fichiers YAML avec l'événement `on: push: branches: [main]`, les deux workflows se déclenchent **en même temps et en parallèle**.

Si le déploiement de votre site échoue, le job de Release risque quand même de s'exécuter et de publier une version erronée.

---

## 🛠️ La Solution : L'événement `workflow_run`

GitHub Actions propose l'événement `workflow_run` qui permet à un workflow de **s'abonner aux événements d'un autre workflow**.

### Étape 1 : Identifier le NOM exact du Workflow A (Déclencheur)

Dans le premier fichier (ex: `.github/workflows/deploy.yml`), repérez la valeur de la clé `name:` à la ligne 1 :

```yaml
# .github/workflows/deploy.yml
name: Deploy MkDocs to GitHub Pages  # <-- C'est ce nom exact qu'il faut utiliser !

on:
  push:
    branches:
      - main
```

---

### Étape 2 : Configurer le Workflow B (Dépendance)

Dans le second fichier (ex: `.github/workflows/verify-and-release.yml`), remplacez le déclencheur `on: push` par le bloc `workflow_run` :

```yaml
# .github/workflows/verify-and-release.yml
name: Release

on:
  workflow_run:
    workflows: ["Deploy MkDocs to GitHub Pages"] # Nom exact du workflow A
    types:
      - completed # S'active lorsque le workflow A s'est terminé

jobs:
  release:
    name: Release
    runs-on: ubuntu-latest
    # CONDITION CRITIQUE : Ne s'exécute QUE si le workflow A a RÉUSSI !
    if: ${{ github.event.workflow_run.conclusion == 'success' }}
    permissions:
      contents: write
      issues: write
      pull-requests: write
      id-token: write
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: "lts/*"

      - name: Install dependencies
        run: npm clean-install

      - name: Verify dependencies signatures
        run: npm audit signatures

      - name: Release
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: npx semantic-release
```

---

## 🔍 Comment fonctionne la condition `if` ?

L'événement `types: [completed]` se déclenche dès que le workflow A se termine, **qu'il ait réussi ou échoué**.

C'est la ligne `if:` qui sécurise l'exécution :

```yaml
if: ${{ github.event.workflow_run.conclusion == 'success' }}
```

* **Si le Workflow A est vert (Success)** ➔ Le job `release` s'exécute.
* **Si le Workflow A est rouge (Failure)** ➔ Le job `release` est ignoré (*Skipped*) et n'exécute aucune action de publication.
