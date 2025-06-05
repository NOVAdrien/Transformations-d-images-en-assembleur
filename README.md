# Projet Transformations d'Images XPM2 (C)

Ce projet permet de lire, transformer et sauvegarder des images au format **XPM2** à l'aide de fonctions écrites en langage **C**.

---

## Contenu du projet

### Une partie en C dans C_xpm avec :

- `main.c` : interface utilisateur interactive en ligne de commande
- `xpm2.h` / `xpm2.c` : lecture et écriture de fichiers XPM2
- `transform.h` / `transform.c` : fonctions de transformation (translation, rotation, homothétie)
- `logo.xpm` : image XPM2 de base à transformer
- `Makefile` : compilation automatisée + nettoyage

### Une partie en assembleur dans RARS_xpm avec :

- `main.asm` : interface utilisateur interactive en ligne de commande
- `input.xpm` : image XPM2 de base à transformer
- `output.xpm` : image XPM2 de de retour transformée
---

## Compilation

### Pour le C :

Dans le terminal, depuis le dossier du projet :

    make

Cela génère l'exécutable `xpm2_app`.

### Pour l'assembleur :

Assembler le fichier sur le logiciel assembleur avec le menu ou la touche f3.

---

## Lancer le programme

### Pour le C :

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

### Pour l'assembleur :

Le fichier .xpm qui sera transformé par défaut est donnée dans le .data avec son chemin absolut `InputFilePath`, à modifier si besoin. Exécuter le fichier avec le menu ou la touche f5.

---

## Nettoyage

Pour supprimer les fichiers générés en C (sauf `logo.xpm`) :

    make clean

---

## Remarques

- Le format utilisé est **XPM2** (lisible, non compilable C).
- L'affichage ASCII permet de voir les pixels transformés.
- Le fond est géré automatiquement si défini par `" c None"` dans la palette.
- Les transformations sont **discrètes** (pas d'interpolation).

---

## Approfondissements

- Ajout d’un système de chaînage de transformations
- Voir comment faire les mêmes transformations sur un fichier au format XPM1 (structure du fichier différente)

---

## Auteurs

- Kareem Abi Kaedbey
- Adrien Panguel
