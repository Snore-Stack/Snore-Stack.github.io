# GitHub Pages

**GitHub Pages** est un service d’hébergement de sites web statiques proposé par GitHub. Il permet de publier directement un site web (HTML, CSS, JavaScript, ou site *statiquement généré* comme MkDocs) à partir d’un dépôt GitHub.

---

## 🌐 Caractéristiques Principales

* **Hébergement Gratuit** : Inclus avec tout compte GitHub (publics ou privés avec GitHub Pro).
* **HTTPS Automatique** : Certificat SSL fourni et géré gratuitement par GitHub.
* **Domaines Personnalisés** : Possibilité d'associer un nom de domaine personnalisé (ex: `docs.mondomaine.com`).
* **Intégration CI/CD Négative** : Déploiement direct via la branche de votre choix ou via **GitHub Actions**.

---

## 🔗 URL par Défaut du Site

L'URL de votre site dépend du type de dépôt :

| Type de Dépôt                       | Nom du Dépôt           | URL Générée                                |
| :---------------------------------- | :--------------------- | :----------------------------------------- |
| **Site Utilisateur / Organisation** | `<username>.github.io` | `https://<username>.github.io/`            |
| **Site de Projet**                  | `mon-projet`           | `https://<username>.github.io/mon-projet/` |

---

## ⚙️ Modes de Déploiement

GitHub Pages propose 2 méthodes pour publier votre contenu :

1. **Déploiement depuis une Branche (Legacy)** : GitHub construit le site automatiquement à chaque push sur une branche dédiée (ex: `gh-pages` ou `main/docs`).
2. **Déploiement via GitHub Actions (Recommandé & Moderne)** : Un workflow GitHub Actions génère le site HTML/CSS (ex: via `mkdocs build`) et publie l'artefact directement sur les serveurs d'hébergement GitHub Pages.

---

## ⚠️ Limites & Bonnes Pratiques

* **Contenu Statique Uniquement** : Pas d'exécution de code serveur (pas de PHP, Node.js backend, Python Flask, ou bases de données SQL).
* **Taille Maximale** : Limite du dépôt conseillée à 1 Go, bande passante de 100 Go par mois.
* **Timeout de build** : Le job de build/déploiement **natif** est interrompu s'il dépasse 10 minutes, contre 6 heures pour un job **personnalisé**.
