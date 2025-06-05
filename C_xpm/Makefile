# Nom de l'exécutable
EXEC = xpm2_app

# Fichiers source et objets
SRC = ./src/main.c ./src/xpm2.c ./src/transform.c
OBJ = $(SRC:.c=.o)

# Compilateur et options
CC = gcc
CFLAGS = -Wall -Wextra -std=c99

# Règle par défaut : compilation
all: $(EXEC)

$(EXEC): $(OBJ)
	$(CC) $(OBJ) -o $(EXEC)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	find . -maxdepth 1 -name "*.xpm" ! -name "logo.xpm" -delete
	rm -f $(EXEC) *.o
	rm -f ./images/*.xpm


.PHONY: all clean
