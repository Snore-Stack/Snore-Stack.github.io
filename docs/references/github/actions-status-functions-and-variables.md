# Référence : Fonctions de Statut & Variables GitHub Actions

Aide-mémoire synthétique des fonctions conditionnelles (`if:`) et des variables d'environnement dans GitHub Actions.

---

## ⚡ Fonctions de statut d'exécution (`if:`)

| Fonction | Description |
| :--- | :--- |
| **`success()`** | Vrai si toutes les étapes/jobs précédents ont réussi. *(Comportement par défaut)* |
| **`always()`** | Vrai **toujours**, même si une étape précédente a échoué ou a été annulée. *(Utile pour `docker compose down`)* |
| **`failure()`** | Vrai si au moins un composant précédent a échoué. *(Utile pour l'envoi d'alertes)* |
| **`cancelled()`** | Vrai si le workflow a été annulé manuellement par un utilisateur. |

---

## 🌐 Fichiers d'environnement & Variables système

| Fichier / Variable | Rôle | Exemple d'utilisation |
| :--- | :--- | :--- |
| **`$GITHUB_ENV`** | Fichier système pour exporter des variables aux étapes suivantes. | `echo "PORT=8080" >> $GITHUB_ENV` |
| **`${{ env.VAR }}`** | Syntaxe d'accès aux variables d'environnement dans le YAML. | `http://localhost:${{ env.PORT }}` |
| **`${{ secrets.GITHUB_TOKEN }}`** | Jeton d'authentification temporaire généré pour chaque job. | Requis pour `semantic-release` ou `gh-pages` |

---

## 🔄 Propriétés de l'événement `workflow_run`

| Propriété | Description |
| :--- | :--- |
| **`github.event.workflow_run.conclusion`** | Statut du workflow déclencheur (`'success'`, `'failure'`, `'cancelled'`). |
| **`github.event.workflow_run.head_branch`** | Nom de la branche sur laquelle s'est exécuté le workflow déclencheur (ex: `'main'`). |
