#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "xpm2.h"
#include "transform.h"

int main() {
    char filename[100];
    printf("Nom du fichier XPM2 à charger : ");
    scanf("%s", filename);

    XPMImage *img = read_xpm2(filename);
    if (!img) {
        fprintf(stderr, "Erreur de lecture du fichier %s\n", filename);
        return 1;
    }

    int choix;
    do {
        printf("\n--- Menu Transformations XPM2 ---\n");
        printf("1. Translation\n");
        printf("2. Rotation 90°\n");
        printf("3. Rotation 180°\n");
        printf("4. Rotation 270°\n");
        printf("5. Homothétie centrée\n");
        printf("6. Quitter\n");
        printf("Choix : ");
        scanf("%d", &choix);

        XPMImage *result = NULL;
        char outname[100];

        switch (choix) {
            case 1: {
                int dx, dy;
                printf("dx (horizontal) : ");
                scanf("%d", &dx);
                printf("dy (vertical) : ");
                scanf("%d", &dy);
                result = translate_xpm2(img, dx, dy);
                strcpy(outname, "./images/translated.xpm");
                break;
            }
            case 2:
                result = rotate90_xpm2(img);
                strcpy(outname, "./images/rotated90.xpm");
                break;
            case 3:
                result = rotate180_xpm2(img);
                strcpy(outname, "./images/rotated180.xpm");
                break;
            case 4:
                result = rotate270_xpm2(img);
                strcpy(outname, "./images/rotated270.xpm");
                break;
            case 5: {
                float factor;
                printf("Facteur d'homothétie (> 0) : ");
                scanf("%f", &factor);
                result = homothety_xpm2(img, factor);
                strcpy(outname, "./images/homothety.xpm");
                break;
            }
            case 6:
                printf("Au revoir !\n");
                break;
            default:
                printf("Choix invalide.\n");
        }

        if (result) {
            write_xpm2(outname, result);
            printf("Résultat enregistré dans %s\n", outname);
            free(result->pixels);
            free(result);
        }

    } while (choix != 6);

    free(img->pixels);
    free(img);
    return 0;
}
