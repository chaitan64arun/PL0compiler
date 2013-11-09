#ifndef STRUCT_H
#define STRUCT_H

#include "plGlobal.h"
typedef struct 
{
  int dx;
  int tx0;
  int cx0;
} myBlock;
myBlock block[LEVMAX];

typedef struct
{
  int i;
  int cx1;
  int cx2;
} myStatement;
myStatement statement[100];

int factor_i[100];
#endif
