# Snore-Stack Documentation Repository

[![semantic-release: angular](https://img.shields.io/badge/semantic--release-angular-e10079?logo=semantic-release)](https://github.com/semantic-release/semantic-release)
[![Deploy](https://github.com/snore-stack/snore-stack.github.io/actions/workflows/deploy.yml/badge.svg)](https://github.com/snore-stack/snore-stack.github.io/actions/workflows/deploy.yml/badge.svg)

Welcome to the source repository of the **Snore-Stack** documentation, hosted on **[snore-stack.github.io](https://snore-stack.github.io/)** and maintained by **[@vpraion](https://github.com/vpraion)** and **[@AraaCraft](https://github.com/AraaCraft)**.

---

## 🛠️ Local Development

### Requirements
* **Node.js** `>= 18.0.0`
* **Docker**

### 1. Clone and install hooks
```bash
git clone git@github.com:Snore-Stack/Snore-Stack.github.io.git
cd Snore-Stack.github.io
npm install
```
*(The `npm install` command automatically enables Husky to validate commit messages locally).*

### 2. Serve the documentation locally
```bash
docker-compose up -d
```
Available locally at [http://localhost:8000](http://localhost:8000).

---

## 📝 Commits & Releases

This repository uses **Conventional Commits** (enforced by **Commitlint**) and **Semantic Release**.

```bash
feat(git): add new page for git hooks    # Triggers a MINOR version
fix(ui): fix search bar styling          # Triggers a PATCH version
```

---

## 📂 Project Structure

The documentation is written in the `docs/` directory following the [Diátaxis framework](docs/references/architecture/diataxis-framework.md):

```text
docs/
├── index.md        # Home page (Philosophy & Overview)
├── how-to/         # Step-by-step practical guides
└── references/     # Reference sheets & Standards
```
