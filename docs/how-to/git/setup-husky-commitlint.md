# Comment installer et configurer Husky avec Commitlint

Ce guide explique pas à pas comment mettre en place la validation automatique des messages de commit (**Conventional Commits**) en couplant **Husky** et **Commitlint**.

---

## 📋 Prérequis

Avant d'exécuter les commandes, s'assurer d'avoir :

* **Git** : `>= 2.13.0`
* **Node.js** : `>= 18.0.0`
* Un projet avec un fichier `package.json` à la racine (`npm init` effectué).

---

## 🛠️ Étapes d'installation pas à pas

### 1. Installer les dépendances de développement

Installez **Commitlint** (l'analyseur de syntaxe) et **Husky** (le déclencheur de Git Hook) dans votre projet :

```bash
npm install --save-dev @commitlint/cli @commitlint/config-conventional husky
```

---

### 2. Configurer Commitlint

Créez le fichier de configuration `.commitlintrc.json` à la racine de votre projet pour activer le jeu de règles standard des Conventional Commits :

```bash
echo '{"extends": ["@commitlint/config-conventional"]}' > .commitlintrc.json
```

---

### 3. Initialiser Husky

Initialisez Husky afin de créer le dossier `.husky/` et d'activer les hooks :

```bash
npx husky init
```

Cette commande effectue automatiquement :
1. La création du dossier `.husky/`.
2. L'ajout du script `"prepare": "husky"` dans votre `package.json` (pour l'installation automatique chez vos collègues lors d'un `npm install`).
3. La création d'un fichier d'exemple `.husky/pre-commit` contenant `npm test`.

> 💡 **Nettoyage recommandé** : Si votre projet n'utilise pas de script de test ou si vous ne voulez pas exécuter vos tests à chaque commit, supprimez simplement ce fichier d'exemple :
> ```bash
> rm .husky/pre-commit
> ```

---

### 4. Créer le Hook `commit-msg`

Créez le script d'interception dans `.husky/commit-msg` pour lier le hook `commit-msg` à Commitlint :

```bash
# 1. Écrire la commande d'exécution dans .husky/commit-msg
echo "npx --no -- commitlint --edit \$1" > .husky/commit-msg

# 2. Donner les droits d'exécution au fichier (macOS / Linux)
chmod +x .husky/commit-msg
```

---

## 🧪 Tester la validation

1. Indexez un fichier modifié :
   ```bash
   git add .
   ```
2. Testez un commit non conforme :
   ```bash
   git commit -m "mauvais message"
   ```
   ❌ **Résultat** : Commitlint intercepte le message et **annule le commit**.

3. Testez un commit conforme :
   ```bash
   git commit -m "feat(auth): add google oauth2 login"
   ```
   ✅ **Résultat** : Le commit est validé et enregistré par Git.
