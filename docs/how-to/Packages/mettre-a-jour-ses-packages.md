# Mettre à jour ses paquets

## Distribution basée sur `Arch`

### La commande standard (recommandée)

- Met à jour la base de données des dépôts et met à niveau l'ensemble des paquets du système.
- Évite les ruptures de dépendances liées aux mises à jour partielles (partial upgrades).
```bash
sudo pacman -Syu
```
### Mise à jour de la liste des paquets

- Télécharge et synchronise la dernière liste des paquets disponibles depuis les dépôts distants.
- N'installe ni ne met à niveau aucun paquet sur la machine.
```bash
sudo pacman -Sy
```
### Mise à niveau sans synchronisation

- Met à jour les paquets installés uniquement à partir de la base de données locale actuelle.
- Ne contacte pas les serveurs pour vérifier s'il existe de nouvelles versions de listes.
```bash
sudo pacman -Su
```
