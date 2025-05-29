// xpm2.c

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
    int line_num = 0, pixel_row = 0;

    while (fgets(line, sizeof(line), fp)) {
        if (line[0] == '\n' || line[0] == '!') continue;
        line[strcspn(line, "\r\n")] = 0;

        if (line_num == 0) {
            sscanf(line, "%d %d %d %d", &img->width, &img->height,
                   &img->num_colors, &img->chars_per_pixel);
            img->pixels = malloc(img->width * img->height);
        }
        else if (line_num <= img->num_colors) {
            char symbol[8], colorname[16];
            sscanf(line, "%s c %s", symbol, colorname);
            img->symbols[line_num - 1] = symbol[0];
            strncpy(img->colors[line_num - 1], colorname, 15);
        }
        else {
            for (int i = 0; i < img->width; ++i)
                img->pixels[pixel_row * img->width + i] = line[i];
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
            fprintf(fp, "%c", img->pixels[y * img->width + x]);
        }
        fprintf(fp, "\n");
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
