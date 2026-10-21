# Rechercher un paquet

## Distribution basée sur `Arch`

### Rechercher dans les dépôts distants

- Recherche un paquet par mot-clé dans le nom et la description sur les dépôts officiels.
```bash
pacman -Ss <mot_cle>
```

### Rechercher parmi les paquets déjà installés

- Recherche un mot-clé uniquement dans la liste des paquets installés localement.
```bash
pacman -Qs <mot_cle>
```

### Obtenir des informations détaillées sur un paquet

- Affiche les détails (version, dépendances, taille, auteur) d'un paquet distant.
```bash
pacman -Si <nom_du_paquet>
```

- Affiche les informations complètes d'un paquet déjà installé sur votre machine.
```bash
pacman -Qi <nom_du_paquet>
```

### Trouver le paquet propriétaire d'un fichier

- Permet d'identifier quel paquet a installé un fichier ou une commande spécifique du système.
```bash
pacman -Qo /chemin/vers/fichier
```
