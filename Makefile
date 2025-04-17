# === Variables ===

CC = gcc
CFLAGS = -Wall -Wextra -std=c99
SRC_DIR = src
BUILD_DIR = build
BIN = $(BUILD_DIR)/image_transform

SRCS = $(SRC_DIR)/main.c \
       $(SRC_DIR)/io.c \
       $(SRC_DIR)/transform.c

OBJS = $(SRCS:.c=.o)

# === Regles ===

all: $(BIN)

$(BIN): $(SRCS)
	@mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) $(SRCS) -o $(BIN) -lm
	@echo "Compilation terminee."

clean:
	rm -rf $(BUILD_DIR)
	@echo "Nettoyage termine."

run: all
	./$(BIN)

.PHONY: all clean run
