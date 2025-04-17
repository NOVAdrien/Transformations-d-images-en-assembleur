#ifndef IO_H
#define IO_H

typedef struct {
    unsigned char r, g, b;
} Pixel;

typedef struct {
    int width;
    int height;
    Pixel *data;
} Image;

int lire_ppm(const char *filename, Image *img);
int ecrire_ppm(const char *filename, const Image *img);

#endif
