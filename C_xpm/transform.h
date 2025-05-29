// transform.h

#ifndef TRANSFORM_H
#define TRANSFORM_H

#include "xpm2.h"

// Applique une translation (dx, dy) à l'image
// Retourne une NOUVELLE image (à free par l'utilisateur)
XPMImage* translate_xpm2(const XPMImage *img, int dx, int dy);

// Applique une rotation de 90 degrés dans le sens horaire autour du centre de l'image.
// Retourne une nouvelle image allouée dynamiquement (à libérer par l'utilisateur).
XPMImage* rotate90_xpm2(const XPMImage *img);


// Applique une rotation de 180 degrés autour du centre de l'image.
// Retourne une nouvelle image allouée dynamiquement.
XPMImage* rotate180_xpm2(const XPMImage *img);

// Applique une rotation de 270 degrés dans le sens horaire (90° antihoraire).
// Retourne une nouvelle image allouée dynamiquement.
XPMImage* rotate270_xpm2(const XPMImage *img);


// Applique une mise à l'échelle à l'image (agrandissement ou réduction).
// Le facteur > 1 agrandit, < 1 réduit. Retourne une nouvelle image allouée dynamiquement.
XPMImage* scale_xpm2(const XPMImage *img, float factor);


// Applique une homothétie centrée de facteur k à l'image.
// Le centre est celui de l'image. Retourne une nouvelle image allouée dynamiquement.
XPMImage* homothety_xpm2(const XPMImage *img, float factor);


#endif
