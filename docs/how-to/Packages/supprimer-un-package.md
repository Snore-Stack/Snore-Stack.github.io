# Supprimer un paquet

## Distribution basée sur `Arch`

### La commande standard (recommandée)

- Supprime le paquet et **ses dépendances devenues inutiles** (qui ne sont requises par aucun autre paquet).
- Évite d'accumuler des paquets orphelins.
```bash
sudo pacman -Rs <nom_du_paquet>
```

### La purge complète

- Fait la même chose que `-Rs`, mais supprime également les fichiers de configuration globaux (fichiers `.pacsave`).
```bash
sudo pacman -Rns <nom_du_paquet>
```

### Suppression simple

- Supprime uniquement le paquet spécifié.
- Laisse ses dépendances et ses configurations sur le système.
- Échoue si d'autres paquets dépendent encore de lui.
```bash
sudo pacman -R <nom_du_paquet>
```
