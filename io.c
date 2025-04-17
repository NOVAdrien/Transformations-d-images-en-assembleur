#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "io.h"

int lire_ppm(const char *filename, Image *img) {
    FILE *f = fopen(filename, "rb");
    if (!f) return 0;

    char format[3];
    fscanf(f, "%2s", format);
    if (strcmp(format, "P6") != 0) return 0;

    int maxval;
    fscanf(f, "%d %d %d", &img->width, &img->height, &maxval);
    fgetc(f); // consommer le \n

    img->data = malloc(img->width * img->height * sizeof(Pixel));
    fread(img->data, sizeof(Pixel), img->width * img->height, f);
    fclose(f);
    return 1;
}

int ecrire_ppm(const char *filename, const Image *img) {
    FILE *f = fopen(filename, "wb");
    if (!f) return 0;
    fprintf(f, "P6\n%d %d\n255\n", img->width, img->height);
    fwrite(img->data, sizeof(Pixel), img->width * img->height, f);
    fclose(f);
    return 1;
}
