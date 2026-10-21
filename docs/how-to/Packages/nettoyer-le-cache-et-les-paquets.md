# Nettoyer le cache et les paquets orphelins

## Distribution basée sur `Arch`

### Nettoyer les anciennes versions en cache (`paccache`)

- Conserve uniquement les 3 dernières versions des paquets téléchargés dans `/var/cache/pacman/pkg/` (nécessite le paquet `pacman-contrib`).
- Permet de conserver une possibilité de retour en arrière (*downgrade*) tout en libérant de l'espace disque.
```bash
paccache -r
```

### Vider le cache de `pacman`

- Supprime les archives des paquets qui ne sont plus installés sur le système.
```bash
sudo pacman -Sc
```

- Supprime l'intégralité des archives en cache (libération maximale d'espace disque).
```bash
sudo pacman -Scc
```

### Supprimer les paquets orphelins

- Recherche et supprime toutes les dépendances devenues inutiles qui ne sont requises par aucun logiciel actif.
```bash
sudo pacman -Rns $(pacman -Qdtq)
```

!!! warning "Disclaimer : Attention aux faux orphelins"
    Cette commande comporte un risque si elle est exécutée aveuglément :

    - **Paquets utiles installés comme dépendances :** Si un outil (ex. `git`, `python`, `curl`) a été installé à l'origine en tant que dépendance d'un autre logiciel que vous avez supprimé depuis, `pacman` le considérera comme orphelin et voudra le supprimer.
    - **Dépendances optionnelles (*opt-depends*) :** Certains composants (codecs audio/vidéo, extensions, polices) peuvent être supprimés alors qu'ils servent à d'autres applications.

#### Bonnes pratiques recommandées :

1. **Lister et vérifier les orphelins avant suppression :**
    ```bash
    pacman -Qdt
    ```

2. **Conserver un paquet utile** (le marquer comme installé explicitement pour qu'il ne soit plus ciblé) :
    ```bash
    sudo pacman -D --asexplicit <nom_du_paquet>
    ```

3. **Ne jamais ajouter `--noconfirm`** : prendre toujours quelques secondes pour relire la liste affichée par `pacman` avant de valider.
