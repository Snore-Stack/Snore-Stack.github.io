# Conventional Commits

La spécification **[Conventional Commits](https://www.conventionalcommits.org)** est une structure de messages de commit.

---

## 📝 Format standard

```text
type(scope): description

[corps optionnel du message]

[footer(s) optionnel(s)]
```

### 🔍 Comment sont identifiés le Titre, le Corps et les Footers ?

1. **Le Titre (Première ligne)** : La ligne `type(scope): description`.
2. **Le Corps (Body)** :
      *  Séparé du titre par **une ligne vide**.
      * Contient du texte libre. Explique le *pourquoi* et le *comment*.
3. **Les Footers** :
      * Séparés du corps par **une ligne vide**.
      * Se trouvent obligatoirement tout en bas du message.
      * Suivent la structure clé/valeur : `Clé: Valeur` (ex: `BREAKING CHANGE: ...` ou `Fixes: #12`).

---

## 📚 Les 11 Types Officiels

### 🚀 Types impactant la version publique (*Déclenchent une release*)

| Type                 | Rôle                                                                        | Impact SemVer        | Exemple de commit                           |
| :------------------- | :-------------------------------------------------------------------------- | :------------------- | :------------------------------------------ |
| **`feat`**           | Ajout d'une nouvelle fonctionnalité                                         | **MINOR** (`v1.x.0`) | `feat(auth): add Google OAuth2 login`       |
| **`fix`**            | Correction d'un bug                                                         | **PATCH** (`v1.0.x`) | `fix(cart): prevent negative item quantity` |
| **`!`** *(Breaking)* | Modification cassant la rétrocompatibilité (en suffixe du type ou du scope) | **MAJOR** (`vX.0.0`) | `feat(api)!: remove v1 endpoints`           |

---

### 🛠️ Qualité du Code & Maintenance

| Type           | Rôle                                                                                  | Exemple de commit                               |
| :------------- | :------------------------------------------------------------------------------------ | :---------------------------------------------- |
| **`docs`**     | Documentation uniquement (README, guides, docstrings)                                 | `docs(readme): add docker-compose instructions` |
| **`style`**    | Formatage et linter du code source (espaces, indentation sans modif logique/visuelle) | `style(ui): reformat CSS with prettier`         |
| **`refactor`** | Restructuration du code sans modif fonctionnelle ni fix                               | `refactor(db): simplify user query logic`       |
| **`perf`**     | Amélioration des performances d'exécution ou mémoire                                  | `perf(images): implement lazy loading on feed`  |
| **`test`**     | Ajout ou modification de tests unitaires                                              | `test(auth): add test case for expired JWT`     |
| **`chore`**    | Maintenance diverse, fichiers ignorés ou tâches courantes                             | `chore(gitignore): add local debug logs`        |

---

### ⚙️ Outillage, CI/CD & Historique

| Type         | Rôle                                                          | Exemple de commit                             |
| :----------- | :------------------------------------------------------------ | :-------------------------------------------- |
| **`build`**  | Systèmes de build, compilateurs ou mise à jour de dépendances | `build(deps): bump express from 4.18 to 4.19` |
| **`ci`**     | Fichiers de configuration CI/CD et pipelines (GitHub Actions) | `ci(github): add matrix build for Node 20`    |
| **`revert`** | Annulation (*git revert*) d'un commit précédent               | `revert(auth): rollback JWT implementation`   |

---

## 🎯 Convention des Scopes dans la Snore-Stack

Pour couvrir les cas spécifiques (sécurité, infra, UI) sans dévier des 11 types officiels, nous utilisons des **scopes dédiés** :

* 🔒 **Sécurité** ➔ `fix(security): patch XSS vulnerability`
* 🎨 **UI / CSS** ➔ `feat(ui): add dark mode toggle` ou `fix(ui): fix navbar overflow`
* 🏗️ **Infrastructure** ➔ `chore(infra): update Terraform scripts`
* ⚙️ **Configuration** ➔ `chore(config): update CORS allowed origins`
* 🌐 **Traductions** ➔ `feat(i18n): add French language support`

---

## 🛠️ Outillage et Automatisation

Notre workflow s'appuie sur deux outils clés :

### 1. Commitlint (Validation en local)
**[commitlint](https://commitlint.js.org/)** s'exécute en local lors du `git commit` (via des hooks Git). Il valide la syntaxe et s'assure que le `type` utilisé fait bien partie des 11 types officiels. Si le message est mal formé, le commit est bloqué.

### 2. Semantic Release (Automation CI/CD)
En CI/CD sur la branche `main`, **[semantic-release](https://github.com/semantic-release/semantic-release)** analyse l'historique des commits validés :
* **`feat`** ➔ Génère automatiquement une version **MINOR** (`v1.x.0`).
* **`fix`** ➔ Génère automatiquement une version **PATCH** (`v1.0.x`).
* **`!`** (ex: `feat!:`) ou **`BREAKING CHANGE:`** en footer ➔ Génère une version **MAJOR** (`vX.0.0`).
* Il génère le `CHANGELOG.md`, crée le tag Git et publie la release GitHub.

ℹ️ **Remarque** :

-  `!`se place toujours en suffixe d'un `type` ou d'un `type(scope)`
- On n'écrit jamais de commit de type `release`. C'est `semantic-release` qui gère le versionnement de manière 100% autonome.
