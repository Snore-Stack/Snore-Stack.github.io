# Git Hooks & Husky

Les **Git Hooks** pour automatiser la vérification de la qualité des messages de commit et du code avant leur enregistrement local ou leur publication sur le dépôt distant.

---

## ⚓ Les Git Hooks Natifs

Un **Git Hook** est un script exécuté automatiquement par Git lors d'événements spécifiques de son cycle de vie. Nativement, Git stocke ces scripts dans le dossier caché et non-versionné `.git/hooks/`.

| Nom du Hook      | Moment de déclenchement                                 | Usage standard                                       |
| :--------------- | :------------------------------------------------------ | :--------------------------------------------------- |
| **`commit-msg`** | Lors de la rédaction du message de commit               | Validation du format du message avec **Commitlint**. |
| **`pre-commit`** | Avant la validation du commit                           | Formatage (Prettier) et analyse linter (ESLint).     |
| **`pre-push`**   | Avant l'envoi vers le serveur distant (`git push`)      | Exécution des tests unitaires ou d'intégration.      |
| **`post-merge`** | Après la mise à jour du code local (`git pull`/`merge`) | Mise à jour automatique des dépendances.             |

---

## 🐶 Le partage des Hooks avec Husky

### Le problème des hooks natifs
Le dossier `.git/` étant ignoré par le contrôle de version, les scripts placés dans `.git/hooks/` restent strictement locaux à la machine du développeur. Ils ne sont pas transmis lors d'un `git clone` et ne peuvent pas être imposés à l'équipe.

### La solution : **Husky** & `core.hooksPath`
**[Husky](https://typicode.github.io/husky/)** résout ce problème en s'appuyant sur la fonctionnalité native `core.hooksPath` de Git pour rediriger la lecture des hooks vers un dossier **`.husky/`** placé à la racine du projet :

1. Le dossier `.husky/` contient les scripts de vérification (comme l'appel à **Commitlint**).
2. Le dossier `.husky/` est versionné et partagé avec l'ensemble de l'équipe via Git.
3. Lors de l'installation des dépendances (`npm install`), Husky configure automatiquement le dépôt du développeur pour qu'il s'appuie sur ces hooks partagés.
