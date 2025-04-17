#ifndef TRANSFORM_H
#define TRANSFORM_H

#include "io.h"

Image* appliquer_similitude(Image* img_src, int centre_x, int centre_y, double facteur, double angle);
Image* appliquer_translation(Image* img_src, int decalage_x, int decalage_y);

#endif
