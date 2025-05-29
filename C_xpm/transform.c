// transform.c

#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "transform.h"
 


XPMImage* translate_xpm2(const XPMImage *img, int dx, int dy) {
    // Créer une nouvelle image vide avec mêmes dimensions
    XPMImage *new_img = malloc(sizeof(XPMImage));
    new_img->width = img->width;
    new_img->height = img->height;
    new_img->num_colors = img->num_colors;
    new_img->chars_per_pixel = img->chars_per_pixel;
    new_img->pixels = malloc(img->width * img->height);

    // Copier la palette (symboles et couleurs)
    for (int i = 0; i < img->num_colors; ++i) {
        new_img->symbols[i] = img->symbols[i];
        for (int j = 0; j < 16; ++j)
            new_img->colors[i][j] = img->colors[i][j];
    }

    // Remplir le fond avec la première couleur (supposée être "fond")
    char background = ' ';
    for (int i = 0; i < img->num_colors; ++i) {
        if (strcmp(img->colors[i], "None") == 0) {
            background = img->symbols[i];
            break;
        }
    }
    for (int i = 0; i < img->width * img->height; ++i) {
        new_img->pixels[i] = background;
    }

    // Appliquer la translation inverse
    for (int y = 0; y < img->height; ++y) {
        for (int x = 0; x < img->width; ++x) {
            int src_index = y * img->width + x;
            int dst_x = x + dx;
            int dst_y = y + dy;

            if (dst_x >= 0 && dst_x < img->width &&
                dst_y >= 0 && dst_y < img->height) {
                int dst_index = dst_y * img->width + dst_x;
                new_img->pixels[dst_index] = img->pixels[src_index];
            }
        }
    }

    return new_img;
}



XPMImage* rotate90_xpm2(const XPMImage *img) {
    XPMImage *rotated = malloc(sizeof(XPMImage));
    rotated->width = img->height;
    rotated->height = img->width;
    rotated->num_colors = img->num_colors;
    rotated->chars_per_pixel = img->chars_per_pixel;
    rotated->pixels = malloc(rotated->width * rotated->height);

    // Copier la palette
    for (int i = 0; i < img->num_colors; ++i) {
        rotated->symbols[i] = img->symbols[i];
        strncpy(rotated->colors[i], img->colors[i], 16);
    }

    // Remplir par fond
    char background = ' ';
    for (int i = 0; i < img->num_colors; ++i) {
        if (strcmp(img->colors[i], "None") == 0) {
            background = img->symbols[i];
            break;
        }
    }
    for (int i = 0; i < rotated->width * rotated->height; ++i) {
        rotated->pixels[i] = background;
    }

    // Appliquer la rotation : (x, y) devient (y, H - 1 - x)
    for (int y = 0; y < img->height; ++y) {
        for (int x = 0; x < img->width; ++x) {
            char pixel = img->pixels[y * img->width + x];
            int new_x = y;
            int new_y = img->width - 1 - x;
            rotated->pixels[new_y * rotated->width + new_x] = pixel;
        }
    }

    return rotated;
}


XPMImage* rotate180_xpm2(const XPMImage *img) {
    XPMImage *rotated = malloc(sizeof(XPMImage));
    rotated->width = img->width;
    rotated->height = img->height;
    rotated->num_colors = img->num_colors;
    rotated->chars_per_pixel = img->chars_per_pixel;
    rotated->pixels = malloc(img->width * img->height);

    // Copier la palette
    for (int i = 0; i < img->num_colors; ++i) {
        rotated->symbols[i] = img->symbols[i];
        strncpy(rotated->colors[i], img->colors[i], 16);
    }

    // Fond
    char background = ' ';
    for (int i = 0; i < img->num_colors; ++i)
        if (strcmp(img->colors[i], "None") == 0)
            background = img->symbols[i];

    for (int i = 0; i < img->width * img->height; ++i)
        rotated->pixels[i] = background;

    // Rotation 180° : (x, y) → (W-1-x, H-1-y)
    for (int y = 0; y < img->height; ++y) {
        for (int x = 0; x < img->width; ++x) {
            int src = y * img->width + x;
            int dst_x = img->width - 1 - x;
            int dst_y = img->height - 1 - y;
            int dst = dst_y * img->width + dst_x;
            rotated->pixels[dst] = img->pixels[src];
        }
    }

    return rotated;
}


XPMImage* rotate270_xpm2(const XPMImage *img) {
    XPMImage *rotated = malloc(sizeof(XPMImage));
    rotated->width = img->height;
    rotated->height = img->width;
    rotated->num_colors = img->num_colors;
    rotated->chars_per_pixel = img->chars_per_pixel;
    rotated->pixels = malloc(rotated->width * rotated->height);

    // Copier palette
    for (int i = 0; i < img->num_colors; ++i) {
        rotated->symbols[i] = img->symbols[i];
        strncpy(rotated->colors[i], img->colors[i], 16);
    }

    // Fond
    char background = ' ';
    for (int i = 0; i < img->num_colors; ++i)
        if (strcmp(img->colors[i], "None") == 0)
            background = img->symbols[i];

    for (int i = 0; i < rotated->width * rotated->height; ++i)
        rotated->pixels[i] = background;

    // (x, y) → (H-1 - y, x)
    for (int y = 0; y < img->height; ++y) {
        for (int x = 0; x < img->width; ++x) {
            int src = y * img->width + x;
            int dst_x = img->height - 1 - y;
            int dst_y = x;
            int dst = dst_y * rotated->width + dst_x;
            rotated->pixels[dst] = img->pixels[src];
        }
    }

    return rotated;
}



XPMImage* scale_xpm2(const XPMImage *img, float factor) {
    if (factor <= 0.0f) return NULL;

    int new_width = (int)(img->width * factor);
    int new_height = (int)(img->height * factor);

    if (new_width == 0 || new_height == 0)
        return NULL;

    XPMImage *scaled = malloc(sizeof(XPMImage));
    scaled->width = new_width;
    scaled->height = new_height;
    scaled->num_colors = img->num_colors;
    scaled->chars_per_pixel = img->chars_per_pixel;
    scaled->pixels = malloc(new_width * new_height);

    // Copier palette
    for (int i = 0; i < img->num_colors; ++i) {
        scaled->symbols[i] = img->symbols[i];
        strncpy(scaled->colors[i], img->colors[i], 16);
    }

    // Fond
    char background = ' ';
    for (int i = 0; i < img->num_colors; ++i)
        if (strcmp(img->colors[i], "None") == 0)
            background = img->symbols[i];

    for (int i = 0; i < new_width * new_height; ++i)
        scaled->pixels[i] = background;

    // Mapping inverse
    for (int y = 0; y < new_height; ++y) {
        for (int x = 0; x < new_width; ++x) {
            int src_x = (int)(x / factor);
            int src_y = (int)(y / factor);
            char pixel = img->pixels[src_y * img->width + src_x];
            scaled->pixels[y * new_width + x] = pixel;
        }
    }

    return scaled;
}



XPMImage* homothety_xpm2(const XPMImage *img, float factor) {
    if (factor <= 0.0f) return NULL;

    // Centre de l'image originale
    float cx_in = (img->width - 1) / 2.0f;
    float cy_in = (img->height - 1) / 2.0f;

    // Dimensions de la nouvelle image
    int new_width = (int)(img->width * factor);
    int new_height = (int)(img->height * factor);

    // Centre de la nouvelle image
    float cx_out = (new_width - 1) / 2.0f;
    float cy_out = (new_height - 1) / 2.0f;

    XPMImage *scaled = malloc(sizeof(XPMImage));
    scaled->width = new_width;
    scaled->height = new_height;
    scaled->num_colors = img->num_colors;
    scaled->chars_per_pixel = img->chars_per_pixel;
    scaled->pixels = malloc(new_width * new_height);

    // Copier palette
    for (int i = 0; i < img->num_colors; ++i) {
        scaled->symbols[i] = img->symbols[i];
        strncpy(scaled->colors[i], img->colors[i], 16);
    }

    // Fond par défaut = ' '
    char background = ' ';
    for (int i = 0; i < img->num_colors; ++i)
        if (strcmp(img->colors[i], "None") == 0)
            background = img->symbols[i];

    for (int i = 0; i < new_width * new_height; ++i)
        scaled->pixels[i] = background;

    // Appliquer homothétie inverse
    for (int y_out = 0; y_out < new_height; ++y_out) {
        for (int x_out = 0; x_out < new_width; ++x_out) {
            float x_in_f = (x_out - cx_out) / factor + cx_in;
            float y_in_f = (y_out - cy_out) / factor + cy_in;
            int x_in = (int)(x_in_f + 0.5f);
            int y_in = (int)(y_in_f + 0.5f);

            if (x_in >= 0 && x_in < img->width &&
                y_in >= 0 && y_in < img->height) {
                scaled->pixels[y_out * new_width + x_out] =
                    img->pixels[y_in * img->width + x_in];
            }
        }
    }

    return scaled;
}
