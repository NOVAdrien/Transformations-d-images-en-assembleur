#include <stdio.h>
#include <stdlib.h>
#include "io.h"
#include "transform.h"

int main() {
    Image img_entree;

    // Etape 1 : lire l'image d'entree
    if (!lire_ppm("images/image_entree.ppm", &img_entree)) {
        printf("Erreur : impossible de lire l'image.\n");
        return 1;
    }

    // Etape 2 : appliquer une similitude
    int centre_x = img_entree.width / 2;
    int centre_y = img_entree.height / 2;
    double facteur = 1.2;        // homothetie (agrandissement)
    double angle = 0.3;          // en radians (environ 17 degres)

    Image* img_similitude = appliquer_similitude(&img_entree, centre_x, centre_y, facteur, angle);
    if (!img_similitude) {
        printf("Erreur : transformation similitude echouee.\n");
        free(img_entree.data);
        return 1;
    }

    ecrire_ppm("images/image_similitude.ppm", img_similitude);

    // Etape 3 : appliquer une translation
    int dx = 50;  // vers la droite
    int dy = -30; // vers le haut

    Image* img_translatee = appliquer_translation(&img_entree, dx, dy);
    if (!img_translatee) {
        printf("Erreur : transformation translation echouee.\n");
        free(img_entree.data);
        free(img_similitude->data);
        free(img_similitude);
        return 1;
    }

    ecrire_ppm("images/image_translation.ppm", img_translatee);

    // Etape 4 : liberer la memoire
    free(img_entree.data);
    free(img_similitude->data);
    free(img_similitude);
    free(img_translatee->data);
    free(img_translatee);

    printf("Transformations terminees avec succes !\n");
    return 0;
}
