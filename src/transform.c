#include <math.h>
#include <stdlib.h>
#include "transform.h"
#include "io.h" // pour Image et Pixel

/**
 * Applique une transformation de similitude (rotation + homothetie)
 * autour d'un centre (centre_x, centre_y).
 *
 * @param img_src  : image d'entree
 * @param centre_x : coordonnee x du centre
 * @param centre_y : coordonnee y du centre
 * @param facteur  : facteur d'homothetie (>0)
 * @param angle    : angle de rotation en radians (sens trigo)
 * @return pointeur vers une nouvelle Image transformee
 */
Image* appliquer_similitude(Image* img_src, int centre_x, int centre_y, double facteur, double angle) {
    Image *img_dst = malloc(sizeof(Image));
    img_dst->width = img_src->width;
    img_dst->height = img_src->height;

    int largeur = img_dst->width;
    int hauteur = img_dst->height;
    int nb_pixels = largeur * hauteur;

    Pixel *pixels = malloc(sizeof(Pixel) * nb_pixels);
    img_dst->data = pixels;

    double cos_a = cos(angle);
    double sin_a = sin(angle);

    for (int y_dst = 0; y_dst < hauteur; y_dst++) {
        for (int x_dst = 0; x_dst < largeur; x_dst++) {

            // Coordonnees relatives au centre
            double dx = x_dst - centre_x;
            double dy = y_dst - centre_y;

            // Transformation inverse de la similitude
            double x_src_f = centre_x + (1.0 / facteur) * (dx * cos_a + dy * sin_a);
            double y_src_f = centre_y + (1.0 / facteur) * (-dx * sin_a + dy * cos_a);

            int x_src = (int)round(x_src_f);
            int y_src = (int)round(y_src_f);

            int index_dst = x_dst + y_dst * largeur;

            if (x_src >= 0 && x_src < largeur && y_src >= 0 && y_src < hauteur) {
                int index_src = x_src + y_src * largeur;
                pixels[index_dst] = img_src->data[index_src];
            } else {
                pixels[index_dst] = (Pixel){255, 255, 255}; // blanc
            }
        }
    }

    return img_dst;
}


/**
 * Applique une translation a une image.
 *
 * @param img_src : image d'entree
 * @param decalage_x : decalage horizontal (positif = vers la droite)
 * @param decalage_y : decalage vertical (positif = vers le bas)
 * @return pointeur vers une nouvelle Image translatee
 */
 Image* appliquer_translation(Image* img_src, int decalage_x, int decalage_y) {
    Image *img_dst = malloc(sizeof(Image));
    img_dst->width = img_src->width;
    img_dst->height = img_src->height;

    int largeur = img_dst->width;
    int hauteur = img_dst->height;
    int nb_pixels = largeur * hauteur;

    Pixel *pixels = malloc(sizeof(Pixel) * nb_pixels);
    img_dst->data = pixels;

    for (int y_dst = 0; y_dst < hauteur; y_dst++) {
        for (int x_dst = 0; x_dst < largeur; x_dst++) {

            int x_src = x_dst - decalage_x;
            int y_src = y_dst - decalage_y;

            int index_dst = x_dst + y_dst * largeur;

            if (x_src >= 0 && x_src < largeur && y_src >= 0 && y_src < hauteur) {
                int index_src = x_src + y_src * largeur;
                pixels[index_dst] = img_src->data[index_src];
            } else {
                pixels[index_dst] = (Pixel){255, 255, 255}; // blanc
            }
        }
    }

    return img_dst;
}
