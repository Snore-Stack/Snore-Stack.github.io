# Installer un paquet

## Distribution basée sur `Arch`

### Installation standard (recommandée)

- Télécharge et installe le paquet ainsi que toutes ses dépendances nécessaires.
```bash
sudo pacman -S <nom_du_paquet>
```

### Installer plusieurs paquets

- Permet d'installer plusieurs paquets en une seule commande.
```bash
sudo pacman -S <paquet1> <paquet2> <paquet3>
```

### Installer uniquement si non installé (`--needed`)

- Évite de réinstaller inutilement les paquets déjà présents et à jour sur le système.
```bash
sudo pacman -S --needed <nom_du_paquet>
```

### Installer un paquet local ou téléchargé manuellement

- Permet d'installer un paquet sous forme d'archive locale (au format `.pkg.tar.zst`).
```bash
sudo pacman -U /chemin/vers/le/fichier.pkg.tar.zst
```
