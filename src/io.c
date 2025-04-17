#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "io.h"

// Fonction pour lire une couleur hexadécimale et la convertir en Pixel
static Pixel parse_xpm_color(const char *color_str) {
    Pixel p = {0, 0, 0};
    if (color_str[0] == '#' && strlen(color_str) == 7) {
        sscanf(color_str + 1, "%02hhx%02hhx%02hhx", &p.r, &p.g, &p.b);
    }
    return p;
}

int lire_xpm(const char *filename, Image *img) {
    FILE *f = fopen(filename, "r");
    if (!f) return 0;

    char buffer[256];
    int width, height, nb_couleurs, chars_per_pixel;
    Pixel *palette = NULL;

    // Lire l'en-tête XPM
    while (fgets(buffer, sizeof(buffer), f)) {
        if (sscanf(buffer, "\"%d %d %d %d\"", &width, &height, &nb_couleurs, &chars_per_pixel) == 4) {
            break;
        }
    }

    img->width = width;
    img->height = height;
    img->data = malloc(width * height * sizeof(Pixel));
    if (!img->data) {
        fclose(f);
        return 0;
    }

    // Lire la palette de couleurs
    palette = malloc(nb_couleurs * sizeof(Pixel));
    char **symbols = malloc(nb_couleurs * sizeof(char *)); // Tableau pour stocker les symboles
    if (!palette || !symbols) {
        free(img->data);
        if (palette) free(palette);
        if (symbols) free(symbols);
        fclose(f);
        return 0;
    }

    for (int i = 0; i < nb_couleurs; i++) {
        fgets(buffer, sizeof(buffer), f);
        symbols[i] = malloc(chars_per_pixel + 1); // Allouer pour chaque symbole
        char color_def[256];
        if (sscanf(buffer, "\"%s c %s\"", symbols[i], color_def) == 2) {
            palette[i] = parse_xpm_color(color_def);
	}
    }

    // Lire les pixels
    for (int y = 0; y < height; y++) {
        fgets(buffer, sizeof(buffer), f);
        for (int x = 0; x < width; x++) {
	    char pixel_chars[chars_per_pixel + 1];
	    strncpy(pixel_chars, buffer + x * chars_per_pixel, chars_per_pixel);
	    pixel_chars[chars_per_pixel] = '\0';

	    // Trouver l'index de la couleur dans la palette
	    for (int c = 0; c < nb_couleurs; c++) {
	        if (strcmp(pixel_chars, symbols[c]) == 0) {
	            img->data[x + y * width] = palette[c];
		    break;
		}
	    }
	}
    }

// Libérer la mémoire des symboles
for (int i = 0; i < nb_couleurs; i++) {
    free(symbols[i]);
}

free(symbols);
free(palette);
return 1;
}

int ecrire_xpm(const char *filename, const Image *img) {
    FILE *f = fopen(filename, "w");
    if (!f) return 0;

    // Écrire l'en-tête XPM
    fprintf(f, "/* XPM */\n");
    fprintf(f, "static char *image_xpm[] = {\n");
    fprintf(f, "\"%d %d 1 1\",\n", img->width, img->height); // 1 couleur (blanc)

    // Palette (1 couleur : blanc)
    fprintf(f, "\"X c #FFFFFF\",\n");

    // Écrire les pixels
    for (int y = 0; y < img->height; y++) {
        fputc('"', f);
        for (int x = 0; x < img->width; x++) {
            fputc('X', f);
        }
        fputc('"', f);
        if (y < img->height - 1) fputc(',', f);
        fputc('\n', f);
    }

    fprintf(f, "};\n");
    fclose(f);
    return 1;
}
