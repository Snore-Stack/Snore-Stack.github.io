# Référence : CLI Trivy, Options & Codes de Misconfiguration Docker

Fiche de référence technique répertoriant les commandes CLI, les drapeaux principaux de **Trivy** (Aqua Security) et les règles de misconfiguration Dockerfile courantes.

---

## 🛠️ Commandes CLI Principales

| Commande | Cible | Description |
| :--- | :--- | :--- |
| `trivy image <image>` | Image Docker | Scanne les vulnérabilités de l'OS et des packages applicatifs d'une image. |
| `trivy config <path>` | Dockerfile / IaC | Scanne les erreurs de configuration dans les Dockerfiles ou fichiers Terraform/K8s. |
| `trivy fs <path>` | Fichiers / Projet | Scanne le répertoire projet à la recherche de secrets fuités et dépendances vulnérables. |

---

## ⚙️ Options & Drapeaux de Filtrage (`trivy image` & `trivy config`)

| Drapeau | Type | Description | Exemple |
| :--- | :--- | :--- | :--- |
| **`--severity`** | `string` | Filtre les niveaux de gravité (`UNKNOWN`, `LOW`, `MEDIUM`, `HIGH`, `CRITICAL`). | `--severity HIGH,CRITICAL` |
| **`--exit-code`** | `int` | Code de sortie du processus. `0` = succès constant, `1` = échec si vulnérabilité trouvée. | `--exit-code 1` |
| **`--format`** | `string` | Format de sortie du rapport (`table`, `json`, `sarif`, `template`). | `--format sarif` |
| **`--ignore-unfixed`**| `bool` | Masque les vulnérabilités qui n'ont pas encore de patch/correctif officiel disponible. | `--ignore-unfixed` |
| **`--vuln-type`** | `string` | Type de vulnérabilités ciblées (`os`, `library`). | `--vuln-type os,library` |

---

## 🛡️ Principaux Codes de Misconfiguration Dockerfile (Trivy Config)

| Code Règle | Nom | Gravité | Description & Risque |
| :--- | :--- | :--- | :--- |
| **`DS-0002`** | `Specify non-root USER` | **HIGH** | Exécution du conteneur sous le compte `root`. Risque fort d'évasion de conteneur (*container escape*). |
| **`DS-0026`** | `Add HEALTHCHECK` | **LOW** | Absence d'instruction `HEALTHCHECK` dans le Dockerfile. Réduit la portabilité de la surveillance de santé. |
| **`DS-0005`** | `ADD instead of COPY` | **LOW** | Utilisation de `ADD` au lieu de `COPY`. `ADD` peut extraire des archives ou télécharger des URLs distantes non sécurisées. |
| **`DS-0013`** | `Do not use sudo` | **HIGH** | Utilisation de `sudo` dans le Dockerfile, exposant des privilèges super-utilisateur inutiles. |

---

## 🚀 Options de l'Action GitHub (`aquasecurity/trivy-action`)

| Paramètre | Description | Valeur par défaut |
| :--- | :--- | :--- |
| `image-ref` | Référence de l'image Docker à scanner. | Aucun |
| `scan-type` | Type de scan (`image`, `fs`, `config`). | `image` |
| `format` | Format du rapport (`table`, `sarif`, `json`). | `table` |
| `exit-code` | Code de sortie pour le pipeline. | `0` |
| `severity` | Niveau de sévérité à remonter. | `UNKNOWN,LOW,MEDIUM,HIGH,CRITICAL` |
