# Projet Transformations d'Images XPM2 (C)

Ce projet permet de lire, transformer et sauvegarder des images au format **XPM2** à l'aide de fonctions écrites en langage **C**.

---

## 📦 Contenu du projet

- `main.c` : interface utilisateur interactive en ligne de commande
- `xpm2.h` / `xpm2.c` : lecture et écriture de fichiers XPM2
- `transform.h` / `transform.c` : fonctions de transformation (translation, rotation, homothétie)
- `logo.xpm` : image XPM2 de base à transformer
- `Makefile` : compilation automatisée + nettoyage
- `README.md` : ce fichier

---

## 🧰 Compilation

Dans le terminal, depuis le dossier du projet :

    make

Cela génère l'exécutable `xpm2_app`.

---

## 🚀 Lancer le programme

    ./xpm2_app

Tu seras invité à entrer le nom du fichier XPM2 (par défaut, utilise `logo.xpm`) puis à choisir une transformation :

    --- Menu Transformations XPM2 ---
    1. Translation
    2. Rotation 90°
    3. Rotation 180°
    4. Rotation 270°
    5. Homothétie centrée
    6. Quitter

Chaque transformation génère un fichier de sortie :
- `translated.xpm`
- `rotated90.xpm`, `rotated180.xpm`, etc.
- `homothety.xpm`

---

## 🧹 Nettoyage

Pour supprimer les fichiers générés (sauf `logo.xpm`) :

    make clean

---

## 🧠 Remarques

- Le format utilisé est **XPM2** (lisible, non compilable C).
- L'affichage ASCII permet de voir les pixels transformés.
- Le fond est géré automatiquement si défini par `" c None"` dans la palette.
- Les transformations sont **discrètes** (pas d'interpolation).

---

## 📬 À faire ensuite (si besoin)

- Ajout d’un système de chaînage de transformations
- Export en `.ppm` ou `.png`
- Ajouter dans le main aussi la fonction scale (A voir si on la laisse ou pas)
- Traduction en assembleur RISC-V de certaines fonctions !!!

---

## 👥 Auteurs

- Kareem Abi Kaedbey
- Adrien Panguel
