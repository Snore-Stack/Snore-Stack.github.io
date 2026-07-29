# Initialiser et publier un dépôt Git

```bash
# 1. Initialiser le dépôt local
git init

# 2. Ajouter les fichiers au suivi
git add .

# 3. Créer le premier commit
git commit -m "chore(repo): initial commit"

# 4. Renommer la branche principale
git branch -M main

# 5. Connecter le dépôt distant (GitHub)
git remote add origin git@github.com:USER/REPO.git

# 6. Envoyer le code
git push -u origin main
```
