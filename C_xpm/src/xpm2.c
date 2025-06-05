#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "xpm2.h"

XPMImage* read_xpm2(const char *filename) {
    FILE *fp = fopen(filename, "r");
    if (!fp) {
        perror("Erreur ouverture fichier");
        return NULL;
    }

    char line[MAX_LINE_LEN];
    XPMImage *img = malloc(sizeof(XPMImage));
    if (!img) {
        fclose(fp);
        return NULL;
    }

    int line_num = 0;
    int pixel_row = 0;

    while (fgets(line, sizeof(line), fp)) {
        // Ignore les lignes vides et commentaires
        if (line[0] == '\n' || line[0] == '!') continue;
        
        // Supprime les retours chariot
        line[strcspn(line, "\r\n")] = 0;

        if (line_num == 0) {
            // Lecture de l'en-tête
            if (sscanf(line, "%d %d %d %d", 
                      &img->width, &img->height,
                      &img->num_colors, &img->chars_per_pixel) != 4) {
                fprintf(stderr, "Format d'en-tête invalide\n");
                fclose(fp);
                free(img);
                return NULL;
            }

            // Allocation mémoire pour les pixels
            img->pixels = malloc(img->width * img->height);
            if (!img->pixels) {
                fclose(fp);
                free(img);
                return NULL;
            }
        }
        else if (line_num <= img->num_colors) {
            // Lecture des entrées de couleur
            char *c_pos = strstr(line, " c ");
            if (!c_pos) {
                fprintf(stderr, "Format de couleur invalide à la ligne %d\n", line_num);
                fclose(fp);
                free(img->pixels);
                free(img);
                return NULL;
            }

            // Extraction du symbole (peut contenir des espaces)
            int sym_len = c_pos - line;
            if (sym_len > 0) {
                // Stocke seulement le premier caractère du symbole
                img->symbols[line_num - 1] = line[0];
            } else {
                // Cas où le symbole est vide (espaces seulement)
                img->symbols[line_num - 1] = ' ';
            }

            // Extraction de la couleur (après " c ")
            char *color_start = c_pos + 3;
            strncpy(img->colors[line_num - 1], color_start, 15);
            img->colors[line_num - 1][15] = '\0'; // Garantit la terminaison
        }
        else {
            // Lecture des pixels
            if (pixel_row >= img->height) {
                fprintf(stderr, "Trop de lignes de pixels\n");
                fclose(fp);
                free(img->pixels);
                free(img);
                return NULL;
            }

            for (int i = 0; i < img->width; ++i) {
                if (line[i] == '\0') {
                    fprintf(stderr, "Ligne de pixels trop courte\n");
                    fclose(fp);
                    free(img->pixels);
                    free(img);
                    return NULL;
                }
                img->pixels[pixel_row * img->width + i] = line[i];
            }
            pixel_row++;
        }

        line_num++;
    }

    fclose(fp);
    return img;
}

int write_xpm2(const char *filename, const XPMImage *img) {
    FILE *fp = fopen(filename, "w");
    if (!fp) {
        perror("Erreur d'écriture");
        return -1;
    }

    fprintf(fp, "! XPM2\n");
    fprintf(fp, "%d %d %d %d\n", img->width, img->height,
            img->num_colors, img->chars_per_pixel);

    for (int i = 0; i < img->num_colors; ++i) {
        fprintf(fp, "%c c %s\n", img->symbols[i], img->colors[i]);
    }

    for (int y = 0; y < img->height; ++y) {
        for (int x = 0; x < img->width; ++x) {
            fputc(img->pixels[y * img->width + x], fp);
        }
        fputc('\n', fp);
    }

    fclose(fp);
    return 0;
}

void print_image(const XPMImage *img) {
    printf("Image %dx%d (%d couleurs)\n", img->width, img->height, img->num_colors);
    for (int y = 0; y < img->height; ++y) {
        for (int x = 0; x < img->width; ++x) {
            printf("%c", img->pixels[y * img->width + x]);
        }
        printf("\n");
    }
}