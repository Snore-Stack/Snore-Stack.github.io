# Référence : Directives Healthcheck & Build Docker Compose

Fiche de référence factuelle décrivant les clés et options de configuration des directives `healthcheck` et `build` dans Docker Compose.

---

## 🛠️ Options de la directive `healthcheck`

| Option | Type | Description | Valeur par défaut |
| :--- | :--- | :--- | :--- |
| **`test`** | `string` ou `array` | Commande exécutée dans le conteneur. Code `0` = healthy, `!= 0` = unhealthy. | Aucun |
| **`interval`** | `duration` | Fréquence d'exécution du test (ex: `5s`, `1m`). | `30s` |
| **`timeout`** | `duration` | Temps limite accordé à la commande avant défaillance. | `30s` |
| **`retries`** | `integer` | Nombre d'échecs consécutifs nécessaires avant de marquer `unhealthy`. | `3` |
| **`start_period`** | `duration` | Délai de grâce initial accordé au conteneur au démarrage. | `0s` |

### Formats de la clé `test` :
- **Forme Shell** : `["CMD-SHELL", "wget -qO- http://localhost:8080/healthz || exit 1"]`
- **Forme Exec** : `["CMD", "curl", "-f", "http://localhost:8080/healthz"]`

---

## 🏗️ Options de la directive `build`

| Option | Description | Exemple |
| :--- | :--- | :--- |
| **`context`** | Chemin du répertoire contenant les sources et le Dockerfile. | `./backend` |
| **`dockerfile`** | Nom du fichier Dockerfile. | `Dockerfile` |
| **`target`** | Nom de l'étape (*stage*) du Dockerfile multi-stage à construire. | `builder` ou `runner` |
| **`args`** | Variables de build d'environnement passées au Dockerfile (`ARG`). | `GO_VERSION=1.24` |
