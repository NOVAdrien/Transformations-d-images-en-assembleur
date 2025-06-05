// xpm2.h

#ifndef XPM2_H
#define XPM2_H

#define MAX_COLORS 256
#define MAX_LINE_LEN 512

typedef struct {
    int width, height;
    int num_colors;
    int chars_per_pixel;
    char symbols[MAX_COLORS];
    char colors[MAX_COLORS][16];
    char *pixels; // tableau linéaire : [height * width]
} XPMImage;

// Lecture XPM2
XPMImage* read_xpm2(const char *filename);

// Écriture XPM2
int write_xpm2(const char *filename, const XPMImage *img);

// Affichage ASCII (debug)
void print_image(const XPMImage *img);

#endif
