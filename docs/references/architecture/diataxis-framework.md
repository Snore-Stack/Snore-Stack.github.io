# Cadre Méthodologique de la Documentation (Framework Diátaxis)

Sur ce dépôt, on essaie de structurer l'ensemble des répertoires de documentation selon le **framework Diátaxis**.

L'objectif de cette méthode est d'éviter de tout mélanger dans des fichiers uniques et de permettre au lecteur de trouver immédiatement l'information selon son besoin du moment.

---

## 🧩 Les 4 Piliers du Framework Diátaxis

Le framework classe tout document selon deux axes : l'**orientation** (pratique vs théorie) et le **besoin de l'utilisateur** (apprendre vs travailler).

```text
                        PRATIQUE (Faire)
                               │
            TUTORIELS          │          GUIDES PRATIQUES
         (Tutorials)           │            (How-To)
                               │
 APPRENDRE ────────────────────┼──────────────────── TRAVAILLER
 (L'utilisateur étudie)        │                     (L'utilisateur code)
                               │
            EXPLICATIONS       │            RÉFÉRENCE
           (Explanation)       │           (Reference)
                               │
                        THÉORIE (Comprendre)
```

---

## 📁 Organisation de nos Dossiers

Dans le dossier `docs/`, on sépare les contenus dans 4 répertoires distincts :

### 1. 🎓 `docs/tutorials/` (Apprendre par la pratique)
* **Objectif** : Prendre par la main un débutant et lui faire réussir une première expérience complète.
* **Style** : Directif, étape par étape, bienveillant, sans s'éparpiller dans la théorie.
* **Exemple** : *"Démarrage rapide avec d'un serveur jellyfin en 5 minutes"*.

### 2. 🛠️ `docs/how-to/` (Résoudre un problème précis)
* **Objectif** : Répondre à la question *"Comment accomplir la tâche X ?"* pour quelqu'un qui a déjà les bases.
* **Style** : Axé résultat, recette de cuisine (contient les prérequis et les commandes exactes).
* **Exemple** : *"Comment installer Husky avec Commitlint"*, *"Comment déployer MkDocs sur GitHub Pages"*.

### 3. 📖 `docs/references/` (Consultation rapide & Informations brutes)
* **Objectif** : Servir d'aide-mémoire exhaustif et factuel pendant qu'on travaille.
* **Style** : Neutre, synthétique, rapide à parcourir (tableaux, listes de types, configurations).
* **Exemple** : *"Les 11 types de Conventional Commits"*, *"Liste des événements Git Hooks"*, *"Anatomie d'un Workflow GitHub Actions"*.

### 4. 💡 `docs/explanations/` (Comprendre l'architecture et les choix)
* **Objectif** : Expliquer le contexte, les choix d'architecture et le "pourquoi".
* **Style** : Discursif, illustré de schémas (Mermaid), théorique.
* **Exemple** : *"Pourquoi la Snore-Stack privilégie GitHub Actions et MkDocs"*.

---

## 🎯 Comment choisir où écrire son nouveau document ?

Avant d'écrire une nouvelle page dans la documentation, il faut se poser la question :

* Est-ce une **procédure pas-à-pas avec des commandes** ? ➔ **`how-to/`**
* Est-ce un **tableau de synthèse, une norme ou une liste** ? ➔ **`references/`**
* Est-ce une **explication de concepts ou d'architecture** ? ➔ **`explanations/`**
* Est-ce un **cours guidé pour grand débutant** ? ➔ **`tutorials/`**
