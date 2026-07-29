# Snore-Stack Documentation Repository

[![semantic-release: angular](https://img.shields.io/badge/semantic--release-angular-e10079?logo=semantic-release)](https://github.com/semantic-release/semantic-release)

Bienvenue sur le dépôt source de la documentation **Snore-Stack**, hébergée sur **[snore-stack.github.io](https://snore-stack.github.io/)** et maintenue par **[@vpraion](https://github.com/vpraion)** et **[@AraaCraft](https://github.com/AraaCraft)**.

---

## 🛠️ Développement Local

### Prérequis
* **Node.js** `>= 18.0.0`
* **Docker**

### 1. Cloner et installer les hooks
```bash
git clone git@github.com:Snore-Stack/Snore-Stack.github.io.git
cd Snore-Stack.github.io
npm install
```
*(Le `npm install` active automatiquement Husky pour valider les messages de commit en local).*

### 2. Servir la doc en local
```bash
docker-compose up -d
```
Accès local sur [http://localhost:8000](http://localhost:8000).

---

## 📝 Commits & Releases

Ce dépôt utilise **Conventional Commits** (contrôlé par **Commitlint**) et **Semantic Release**.

```bash
feat(git): add new page for git hooks    # Déclenche une version MINOR
fix(ui): fix search bar styling          # Déclenche une version PATCH
```

---

## 📂 Structure du projet

La documentation est rédigée dans le dossier `docs/` selon le cadre [Diátaxis](docs/references/architecture/diataxis-framework.md) :

```text
docs/
├── index.md        # Page d'accueil (Philosophie & Présentation)
├── how-to/         # Guides pratiques pas-à-pas
└── references/     # Fiches de référence & Normes
```
