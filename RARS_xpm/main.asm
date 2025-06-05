.data
#===INTRO===#
IntroMsg: 		.asciz "Bonjour, je suis capable de modifier un de vos fichiers .xpm\n"

#===INPUT===#
InputFilePath:     	.asciz "D:/Documents/0Polytech Sorbonne/MAIN/MAIN3/S6/Projet architecture/AbiKaedbeyPanguel_Transformations/RARS_xpm/input.xpm"
InputShowMsg:		.asciz "Voici le contenu de votre fichier :\n"
TmaxInput:		.word 8192
InputBuffer:		.space 10000
InputOpenMsgErr: 	.asciz "Impossible d'ouvrir ce fichier d'entrée..."

# === OUTPUT === #
OutputFilePath:		.asciz "D:/Documents/0Polytech Sorbonne/MAIN/MAIN3/S6/Projet architecture/AbiKaedbeyPanguel_Transformations/RARS_xpm/output.xpm"
OutputBuffer:			.space 40000
OutputMsgErr:			.asciz "Ce fichier de sortie n'existe pas..."
OutputBufferMsg:		.asciz "\nVoici votre fichier output :\n"
OutputBufferSizeMsg:		.asciz "Voici la taille de votre fichier : "

# === FORMAT === #
FormatMsgSuccess:		.asciz "Format bien lu !\n"
FormatMsg:			.asciz "Voici le format de votre fichier : "
FormatBuffer:			.asciz "! XPM2\n"
FormatMsgErr:			.asciz "Problème de formatage !\n"
FormatBufferSizeMsg:		.asciz "Voici la taille de votre FormatBuffer : "

# === DIMENSIONS === #
DimMsgSuccess:		.asciz "\nDimensions bien lues !\n"
DimMsg:			.asciz "Voici les dimensions de votre image : "
DimMsgErr:			.asciz "Ce n'est pas une dimensions...\n"
DimBufferSizeMsg:		.asciz "Voici la taille de vos dimensions : "
Length:			.word 0
LengthStr:			.space 12
Width:				.word 0
WidthStr:			.space 12
NbCol:				.word 0
NbColStr:			.space 12
CarPerPixel:			.word 0
CarPerPixelStr:		.space 12

# Table de saut : donnée sauvegardée
    .align 2
jump_table_data:
    .word STORE_WIDTH          # t1 = 0
    .word STORE_HEIGHT         # t1 = 1
    .word STORE_NBCOL          # t1 = 2
    .word STORE_CARPERPIXEL    # t1 = 3
    .word READ_DIM_ERR         # t1 > 3 (gestion d'erreur)

# === PALETTE === #
PaletteMsgSuccess:		.asciz "Palette bien lue !\n"
PaletteReadMsg:		.asciz "Voici les lignes de la palette :\n"
PaletteBuffer:		.space 256
PaletteBufferSizeMsg:	.asciz "Voici la taille de PaletteBuffer : "

# === TRANSFORMATIONS === #
OperMsg: 		.asciz "\nChoisissez une opération à effectuer à votre fichier image :\n 1 : translation\n 2 : rotation90\n 3 : rotation180\n 4 : rotation270\n 5 : homothétie centrée\n"
# Table de saut : choix de transformation
    .align 2
jump_table_transformation:
    .word ETQ1	# Cas 1: Translation
    .word ETQ2	# Cas 2: Rotation 90°
    .word ETQ3	# Cas 3: Rotation 180°
    .word ETQ4	# Cas 4: Rotation 270°
    .word ETQ5	# Cas 5: Homothétie centrée
OperRep: 		.asciz "Vous avez choisi l'opération : "
OperErr:		.asciz "Cette opération n'existe pas...\n"

# === TRANSLATION === #
TranslHorizMsg: 	.asciz "\n\nChoisissez la longueur de déplacement vers la droite (négatif si vers la gauche) :\n"
TranslVertMsg: 	.asciz "\nChoisissez la longueur de déplacement vers le haut (négatif si vers le bas) :\n"

# === HOMOTETIE === #
ScaleFactorMsg:				.asciz "\nChoisissez un facteur d'aggrandissement : "
FacteurRep:					.asciz "Vous avez choisi le facteur : "
FacteurAggrandissementErreurMsg:		.asciz "\nCe n'est pas un facteur d'aggrandissement valable..."

# === GENERAL === #
Newline:		.asciz "\n"
Space:			.asciz " "

.text
.global MAIN

# === Début du code === #
MAIN:

	ori a7, zero, 4
	la a0, IntroMsg
	ecall

	# Ouvrir + lire input.xpm
	jal ra, INPUT

	# Sauvegarder le pointeur vers input dans la pile
	addi sp, sp, -52
	sw s0, 52(sp)

# === Etats des registres importants === #
# s0 : contenu de input.xpm

	# Ouvrir output.xpm : vérifier son existence avant de continuer
	jal ra, OUTPUT

	# Afficher input.xpm : vérifier son contenu
	jal ra, SHOW_INPUT

	# Lire le format ("! XPM2\n")
	jal ra, READ_FORMAT

	# Sauvegarder la taille de FormatBuffer dans la pile
	sw s1, 48(sp)

# === Etats des registres importants === #
# s0 : contenu de input.xpm
# s1 : taille de FormatBuffer

	# Lire et stocker les dimensions de input
	jal ra, READ_DIM

	# Sauvegarder les dimensions de input dans la pile
	sw s2, 44(sp)
	sw s4, 36(sp)
	sw s6, 28(sp)
	sw s8, 20(sp)

# === Etats des registres importants === #
# s0 : contenu de input.xpm
# s1 : taille de FormatBuffer
# s2 : Length
# s4 : Width
# s6 : NbCol
# s8 : CarPerPixel

	jal ra, READ_PALETTE	

	# Sauvegarder la palette de input et sa taille dans la pile
	sw s10, 12(sp)
	sw s11, 8(sp)

# === Etats des registres importants === #
# s0 : contenu de input.xpm
# s1 : taille de FormatBuffer
# s2 : Length
# s4 : Width
# s6 : NbCol
# s8 : CarPerPixel
# s10 : contenu de PaletteBuffer
# s11 : taille de PaletteBuffer

	jal ra, TRANSFORMATION

	# Sauvegarder le pointeur vers le contenu de output dans la pile
	# Re-sauvegarder les dimensions de output
	sw s2, 44(sp)
	sw s4, 36(sp)
	sw a6, 4(sp)
	sw a5, 0(sp)

# === Etats des registres importants === #
# s0 : contenu de input.xpm
# s1 : taille de FormatBuffer
# s2 : Length
# s4 : Width
# s6 : NbCol
# s8 : CarPerPixel
# s10 : contenu de PaletteBuffer
# s11 : taille de PaletteBuffer
# a6 : contenu de OutputBuffer
# a5 : taille de OutputBuffer

	# Réajourner tous les registres par précaution avant l'écriture de output.xpm
	lw a5, 0(sp)
	lw a6, 4(sp)
	lw s11, 8(sp)
	lw s10, 12(sp)
	lw s8, 20(sp)
	lw s6, 28(sp)
	lw s4, 36(sp)
	lw s2, 44(sp)
	lw s1, 48(sp)
	lw s0, 52(sp)

	jal ra, WRITE_OUTPUT

	# Final
	addi sp, sp, 52

	j EXIT

INPUT:

	# Prologue
	addi sp, sp, -16
	sw ra, 0(sp)

	# Ouvrir le fichier input : file descriptor (fd) dans a0
	ori a7, zero, 1024			# Syscall ouverture doc
	la a0, InputFilePath			# Pointeur vers l'adresse de la chaîne
	ori a1, zero, 0			# Flags (0 = read-only)
	lw a2, TmaxInput			# Taille du fichier à ouvrir
	ecall

	blt a0, zero, OPEN_INPUT_ERROR	# Test erreur d'ouverture

	ori t0, a0, 0				# Stocker le fd du fichier ouvert pour la fermeture

	# Lire le fichier input (a0 contient déjà le fd de input)
	ori a7, zero, 63			# Syscall lecture doc
	la a1, InputBuffer			# Adresse du buffer où stocker les données lues
	lw a2, TmaxInput			# Taille max du fichier à lire
	ecall

	ori s0, a1, 0				# Stocker le contenu du fichier lu

	# Fermer le fichier input après lecture
	ori a7, zero, 57			# Syscall fermeture doc
	ori a0, t0, 0				# Descripteur de fichier à fermer
	ecall

	# Epilogue
	lw ra, 0(sp)
	addi sp, sp, 16

	# Retour à main
	jalr zero, 0(ra)

OPEN_INPUT_ERROR:

	# Afficher le message d'erreur
	ori a7, zero, 4
	la a0, InputOpenMsgErr
	ecall

	j EXIT

OUTPUT:

	# Prologue
	addi sp, sp, -16
	sw ra, 0(sp)

	# Ouvrir le fichier output
	ori a7, zero, 1024
	la a0, OutputFilePath
	ori a1, zero, 0
	ecall

	blt a0, zero, OUTPUT_ERROR		# Test erreur d'ouverture

	# Fermer le fichier output après lecture (a0 contient déjà le fd de output)
	ori a7, zero, 57
	ecall

    	# Epilogue
    	lw ra, 0(sp)
    	addi sp, sp, 16

    	# Retour à main
	jalr zero, 0(ra)

OUTPUT_ERROR:

	# Afficher le message d'erreur
	ori a7, zero, 4
	la a0, OutputMsgErr
	ecall

	j EXIT

SHOW_INPUT:

	# Prologue
	addi sp, sp, -16
	sw ra, 4(sp)
	sw s0, 0(sp)

	# Tester l'affichage du contenu de input
	ori a7, zero, 4
	la a0, InputShowMsg
	ecall

	ori t0, zero, 2000			# Taille réelle de notre input.xpm = 1206

SHOW_INPUT_LOOP:

	beq t0, zero, END_SHOW_INPUT

	# Afficher chaque caractère de input
	ori a7, zero, 11
	lb a0, 0(s0)
	ecall

	addi s0, s0, 1			# Compteur lecture + 1
	addi t0, t0, -1			# Compteur taille lue -1

	j SHOW_INPUT_LOOP

END_SHOW_INPUT:

	jal ra, SHOW_ENTER

	# Epilogue
	lw s0, 0(sp)
	lw ra, 4(sp)
	addi sp, sp, 16

	# Retour à main
	jalr zero, 0(ra)

READ_FORMAT:

	# Prologue
	addi sp, sp, -16
	sw ra, 0(sp)

	# Vérifier le bon en-tête XPM2
	la t0, FormatBuffer
	ori s1, zero, 7			# Taille connue : Taille("! XPM2\n") = 7
	ori t1, s1, 0

LOOP_COMPARAISON_FORMAT:

	beq t1, zero, END_FORMAT		# Bon format !

	# Charger chaque caractère pour les comparer
	lb t2, 0(t0)
	lb t3, 0(s0)

	bne t2, t3, ERR_FORMAT		# Mauvais format...

	addi t1, t1, -1			# Compteur taille - 1
	addi t0, t0, 1			# Pointeur lecture format + 1
	addi s0, s0, 1			# Pointeur lecture inputbuffer + 1

	j LOOP_COMPARAISON_FORMAT

ERR_FORMAT:

	ori a7, zero 4
	la a0, FormatMsgErr
	ecall

	j EXIT

END_FORMAT:

	ori a7, zero, 4
	la a0, FormatMsgSuccess
	ecall

	# Afficher le format (FormatBuffer)
	ori a7, zero, 4
	la a0, FormatMsg
	ecall

	ori a7, zero, 4
	la a0, FormatBuffer
	ecall

	# Afficher la taille de FormatBuffer
	ori a7, zero, 4
	la a0, FormatBufferSizeMsg
	ecall

	ori a7, zero, 1
	ori a0, s1, 0
	ecall

	# Epilogue
	lw ra, 0(sp)
	addi sp, sp, 16

	# Retour à main
	jalr zero, 0(ra)

READ_DIM:

	# Prologue
	addi sp, sp, -16
	sw ra, 0(sp)

	ori t0, zero, 10			# Base de 10 pour stocker les nombres
	ori t1, zero, 0			# Nombre de données enregistrées au fur et à mesure
	ori t2, zero, 0			# Stocker chaque groupe de chiffres

READ_DIM_LOOP:

	lb t4, 0(s0)

	# Vérifier si c'est un chiffre ou une fin de groupe de chiffres
	ori a6, zero, ' '
	beq t4, a6, READ_NEXT_DATA
	ori a6, zero, '\n'
	beq t4, a6, READ_DIM_DONE
	ori a6, zero, '0'
	blt t4, a6, READ_DIM_ERR
	ori a6, zero, '9'
	bgt t4, a6, READ_DIM_ERR

	# Convertir le chiffre et l'ajouter au résultat
	addi t4, t4, -48			# Convertir en valeur numérique
	mul t2, t2, t0			# Multiplier le résultat actuel par 10 <=> décaler de 1 bit à gauche
	add t2, t2, t4			# Ajouter le nouveau chiffre à la fin

	addi s0, s0, 1			# Pointeur lecture InputBuffer + 1

	j READ_DIM_LOOP

READ_NEXT_DATA:

	addi s0, s0, 1			# Pointeur lecture InputBuffer + 1

	# Switch
	la t5, jump_table_data		# Charger l'adresse de la table
	slli t6, t1, 2			# t6 = t1 * 4 (offset dans la table)
	add t5, t5, t6			# t5 = JUMP_TABLE + offset
	lw t5, 0(t5)				# Charger l'adresse de saut
	jr t5					# Sauter à la bonne étiquette

STORE_WIDTH:

	ori s2, t2, 0

	j CLEAR_BUFFER

STORE_HEIGHT:

	ori s4, t2, 0

	j CLEAR_BUFFER

STORE_NBCOL:

	ori s6, t2, 0

	j CLEAR_BUFFER

STORE_CARPERPIXEL:

	ori s8, t2, 0

	j CLEAR_BUFFER

CLEAR_BUFFER:

	# Réinitialiser le buffer de chaque groupe de chiffres
	addi t2, zero, 0

	addi t1, t1, 1			# Compteur de données lues + 1

	j READ_DIM_LOOP

READ_DIM_DONE:

	ori s8, t2, 0

	addi s0, s0, 1			# Pointeur lecture InputBuffer + 1

	ori a7, zero, 4
	la a0, DimMsgSuccess
	ecall

	# Afficher les dimensions (s2 : Length, s4 : Width, s6 : NbCol, s8 : CarPerPixel)
	ori a7, zero, 4
	la a0, DimMsg
	ecall

	# Length
	ori a7, zero, 1
	ori a0, s2, 0
	ecall

	jal ra, SHOW_SPACE

	# Width
	ori a7, zero, 1
	ori a0, s4, 0
	ecall

	jal ra, SHOW_SPACE

	# NbCol
	ori a7, zero, 1
	ori a0, s6, 0
	ecall

	jal ra, SHOW_SPACE

	# CarPerPixel
	ori a7, zero, 1
	ori a0, s8, 0
	ecall

	jal ra, SHOW_ENTER

	# Epilogue
	lw ra, 0(sp)
	addi sp, sp, 16

	# Retour à main
	jalr zero, 0(ra)

READ_DIM_ERR:

	ori a7, zero, 4
	la a0, DimMsgErr
	ecall

	j EXIT

SHOW_SPACE:

	# Espace
	ori a7, zero, 11
	ori a0, zero, ' '
	ecall

	# Retour à la fonction précédente
	jalr zero, 0(ra)

SHOW_ENTER:

	# Retour à la ligne
	ori a7, zero, 11
	ori a0, zero, '\n'
	ecall

	# Retour à la fonction précédente
	jalr zero, 0(ra)

READ_PALETTE:

	# Prologue
	addi sp, sp, -16
	sw ra, 0(sp)

	# Initialisation
	la s10, PaletteBuffer
	ori a6, s10, 0			# Remplir en bougeant a6 et conserver s10 au début de PaletteBuffer
	ori s11, zero, 0			# Stocker la taille de PaletteBuffer
	ori t1, s6, 0				# Nombre de couleurs à lire
	lb t2, Newline			# Séparateur de fin de ligne

READ_PALETTE_LOOP:

	addi s11, s11, 1			# Compteur taille PaletteBuffer + 1

	# Lire et stocker chaque caractère
	lb t3, 0(s0)
	sb t3, 0(a6)

	addi s0, s0, 1			# Pointeur lecture InputBuffer + 1
	addi a6, a6, 1			# Pointeur stockage PaletteBuffer + 1

	beq t3, t2, NEXT_PALETTE_ENTRY	# Test fin de ligne

	j READ_PALETTE_LOOP

NEXT_PALETTE_ENTRY:

	addi t1, t1, -1			# Compteur nombre de couleurs - 1

	beqz t1, END_PALETTE

	j READ_PALETTE_LOOP

END_PALETTE:

	ori a7, zero, 4
	la a0, PaletteMsgSuccess
	ecall

	# Afficher la palette
	ori a7, zero, 4
	la a0, PaletteReadMsg
	ecall

	ori a7, zero, 4
	la a0, PaletteBuffer
	ecall

	# Afficher la taille de PaletteBuffer
	ori a7, zero, 4
	la a0, PaletteBufferSizeMsg
	ecall

	ori a7, zero, 1
	ori a0, s11, 0
	ecall

	# Épilogue
	lw ra, 0(sp)
	addi sp, sp, 16

	# Retour à main
	jalr zero, 0(ra)

TRANSFORMATION:

	# Prologue
	addi sp, sp, -16
	sw ra, 0(sp)

	# Demander le type transformation
	ori a7, zero, 4
	la a0, OperMsg
	ecall

	# Lire le type de transformation
	ori a7, zero, 5
	ecall

	ori s1, a0, 0				# Sauvegarder le type de transformation

	# Afficher ce que l'utilisateur a entré
	ori a7, zero, 4
	la a0, OperRep
	ecall

	ori a7, zero, 1
	ori a0, s1, 0
	ecall

	jal ra, WRITE_ENTER

	# Vérifier que la transformation est proposée (entre 1 et 5)
	ori t0, zero, 1
	blt s1, t0, ERR_TYPE_OPE
	ori t0, zero, 5
	bgt s1, t0, ERR_TYPE_OPE

	la t0, jump_table_transformation	# t0 = adresse de la table de saut
	addi s1, s1, -1			# s1 = s1 - 1 (car table commence à 0)
	slli s1, s1, 2			# s1 = (s1 - 1) * 4 (car chaque entrée fait 4 octets)
	add t0, t0, s1			# t0 = adresse de l'entrée dans la table
	lw t1, 0(t0)				# t1 = adresse de la fonction à appeler
	jalr zero, 0(t1)			# Sauter vers le bon traitement

ETQ1:

	# Paramètre déplacement horizontal
	ori a7, zero, 4
	la a0, TranslHorizMsg
	ecall

	ori a7, zero, 5
	ecall

	ori a4, a0, 0				# Sauvegarder le déplacement horizontal

	# Paramètre déplacement vertical
	ori a7, zero, 4
	la a0, TranslVertMsg
	ecall

	ori a7, zero, 5
	ecall

	ori a3, a0, 0				# Sauvegarder le déplacement vertical

	j TRANSLATION

ETQ2:

	la a6, OutputBuffer			# Buffer où écrire le nouveau contenu (sans header)
	ori a4, a6, 0				# Buffer pour écrire le contenu sans toucher à a6 qui pointe au début de ce Buffer
	ori a5, zero, 0			# Sauvegarder le compteur taille de OutputBuffer

	# Nouvelles dimensions
	ori t0, s2, 0				# Sauvegarder la longueur pour les nouvelles dimensions
	ori s2, s4, 0				# Longueur output <- largeur input
	ori s4, t0, 0				# Largeur output <- longueur input

	ori t0, zero, 0			# Compteur lignes : y = 0

LOOP_ROT90_Y:

	beq t0, s4, END_ROT90_LOOP		# Fin du tableau ?

	ori t1, zero, 0			# Compteur colonnes : x = 0

LOOP_ROT90_X:

	beq t1, s2, NEXT_LINE_ROT90	# Fin de la ligne ?

	# Source_x = Width - y - 1
	sub t2, s4, t0
	addi t2, t2, -1

	# Source_y = x
	ori t3, t1, 0

	# Position_pixel_source = (source_y * Length + source_x)
	addi t4, s4, 1			# Ajouter 1 pour le '\n' à la fin de chaque ligne
	mul t4, t3, t4
	add t4, t4, t2

COPY_PIXEL_ROT90:

	add t5, s0, t4

	# Charger le bon pixel et le stocker au bon endroit
	lb t6, 0(t5)
	sb t6, 0(a4)

	j NEXT_PIXEL_ROT90

NEXT_PIXEL_ROT90:

	addi a4, a4, 1			# Compteur stockage + 1
	addi a5, a5, 1			# Compteur taille OutputBuffer + 1
	addi t1, t1, 1			# Compteur colonne + 1

	j LOOP_ROT90_X

NEXT_LINE_ROT90:

	addi t0, t0, 1			# Compteur ligne + 1

	# Stocker '\n' dans le OutputBuffer
	ori t6, zero, '\n'
	sb t6, 0(a4)

	addi a4, a4, 1			# Compteur stockage + 1
	addi a5, a5, 1			# Compteur taille OutputBuffer + 1

	j LOOP_ROT90_Y

END_ROT90_LOOP:

	# Afficher le nouveau contenu de OutputBuffer
	ori a7, zero, 4
	la a0, OutputBufferMsg
	ecall

	ori a7, zero, 4
	ori a0, a6, 0
	ecall

	# Afficher la taille
	ori a7, zero, 4
	la a0, OutputBufferSizeMsg
	ecall

	ori a7, zero, 1
	ori a0, a5, 0
	ecall

	jal ra, WRITE_ENTER

	# Epilogue
	lw ra, 0(sp)
	addi sp, sp, 16

	# Retour à main
	jalr zero, 0(ra)

ETQ3:

	la a6, OutputBuffer			# Buffer où écrire le nouveau contenu (sans header)
	ori a4, a6, 0				# Buffer pour écrire le contenu sans toucher à a6 qui pointe au début de ce Buffer
	ori a5, zero, 0			# Sauvegarder le compteur taille de OutputBuffer

	ori t0, zero, 0			# Compteur lignes : y = 0

LOOP_ROT180_Y:

	beq t0, s4, END_ROT180_LOOP	# Fin du tableau ?

	ori t1, zero, 0			# Compteur colonnes : x = 0
	
LOOP_ROT180_X:

	beq t1, s2, NEXT_LINE_ROT180	# Fin de la ligne ?

	# Source_x = Length - x - 1
	sub t2, s2, t1
	addi t2, t2, -1

	# Source_y = Width - y - 1
	sub t3, s4, t0
	addi t3, t3, -1

	# Position_pixel_source = (source_y * Length + source_x)
	addi t4, s2, 1			# Ajouter 1 pour le '\n' à la fin de chaque ligne
	mul t4, t3, t4
	add t4, t4, t2

COPY_PIXEL_ROT180:

	add t5, s0, t4

	# Charger le bon pixel et le stocker au bon endroit
	lb t6, 0(t5)
	sb t6, 0(a4)

	j NEXT_PIXEL_ROT180

NEXT_PIXEL_ROT180:

	addi a4, a4, 1			# Compteur stockage + 1
	addi a5, a5, 1			# Compteur taille OutputBuffer + 1
	addi t1, t1, 1			# Compteur colonne + 1

	j LOOP_ROT180_X

NEXT_LINE_ROT180:

	addi t0, t0, 1			# Compteur ligne + 1

	# Stocker '\n' dans le OutputBuffer
	ori t6, zero, '\n'
	sb t6, 0(a4)

	addi a4, a4, 1			# Compteur stockage + 1
	addi a5, a5, 1			# Compteur taille buffer + 1

	j LOOP_ROT180_Y

END_ROT180_LOOP:

	# Afficher le nouveau contenu de OutputBuffer
	ori a7, zero, 4
	la a0, OutputBufferMsg
	ecall

	ori a7, zero, 4
	ori a0, a6, 0
	ecall

	# Afficher la taille
	ori a7, zero, 4
	la a0, OutputBufferSizeMsg
	ecall

	ori a7, zero, 1
	ori a0, a5, 0
	ecall

	jal ra, WRITE_ENTER

	# Epilogue
	lw ra, 0(sp)
	addi sp, sp, 16

	# Retour à main
	jalr zero, 0(ra)

ETQ4:

	la a6, OutputBuffer			# Buffer où écrire le nouveau contenu (sans header)
	ori a4, a6, 0				# Buffer pour écrire le contenu sans toucher à a6 qui pointe au début de ce Buffer
	ori a5, zero, 0			# Sauvegarder le compteur taille de OutputBuffer

	# Nouvelles dimensions
	ori t0, s2, 0				# Sauvegarder la longueur pour les nouvelles dimensions
	ori s2, s4, 0				# Longueur output <- largeur input
	ori s4, t0, 0				# Largeur output <- longueur input

	ori t0, zero, 0			# Compteur lignes : y = 0

LOOP_ROT270_Y:

	beq t0, s4, END_ROT270_LOOP	# Fin du tableau ?

	ori t1, zero, 0			# Compteur colonnes : x = 0

LOOP_ROT270_X:

	beq t1, s2, NEXT_LINE_ROT270	# Fin de la ligne ?

	# Source_x = y
	ori t2, t0, 0

	# Source_y = Width - x - 1
	sub t3, s2, t1
	addi t3, t3, -1

	# Position_pixel_source = (source_y * Length + source_x)
	addi t4, s4, 1			# Ajouter 1 pour le '\n' à la fin de chaque ligne
	mul t4, t3, t4
	add t4, t4, t2

COPY_PIXEL_ROT270:

	add t5, s0, t4

	# Charger le bon pixel et le stocker au bon endroit
	lb t6, 0(t5)
	sb t6, 0(a4)

	j NEXT_PIXEL_ROT270

NEXT_PIXEL_ROT270:

	addi a4, a4, 1			# Compteur stockage + 1
	addi a5, a5, 1			# Compteur taille OutputBuffer + 1
	addi t1, t1, 1			# Compteur colonne + 1

	j LOOP_ROT270_X

NEXT_LINE_ROT270:

	addi t0, t0, 1			# Compteur ligne + 1

	# Stocker '\n' dans le OutputBuffer
	ori t6, zero, '\n'
	sb t6, 0(a4)

	addi a4, a4, 1			# Compteur stockage + 1
	addi a5, a5, 1			# Compteur taille OutputBuffer + 1

	j LOOP_ROT270_Y

END_ROT270_LOOP:

	# Afficher le nouveau contenu de OutputBuffer
	ori a7, zero, 4
	la a0, OutputBufferMsg
	ecall

	ori a7, zero, 4
	ori a0, a6, 0
	ecall

	# Afficher la taille
	ori a7, zero, 4
	la a0, OutputBufferSizeMsg
	ecall

	ori a7, zero, 1
	ori a0, a5, 0
	ecall

	jal ra, WRITE_ENTER

	# Epilogue
	lw ra, 0(sp)
	addi sp, sp, 16

	# Retour à main
	jalr zero, 0(ra)

ETQ5:

	la a6, OutputBuffer			# Buffer où écrire le nouveau contenu (sans header)
	ori a1, a6, 0				# Buffer pour écrire le contenu sans toucher à a6 qui pointe au début de ce Buffer
	ori a5, zero, 0			# Sauvegarder le compteur taille de OutputBuffer

	# Demander le facteur d'échelle
	ori a7, zero, 4
	la a0, ScaleFactorMsg
	ecall

	# Lecture du facteur
	ori a7, zero, 5
	ecall

	ori a4, a0, 0				# Stocker facteur d'aggrandissement

	# Affichage facteur
	ori a7, zero, 4
	la a0, FacteurRep
	ecall

	ori a7, zero, 1
	ori a0, a4, 0
	ecall

	blez a4, FACTEUR_AGGRANDISSEMENT_ERREUR

	# Test facteur entier
	ori a3, zero, 1
	rem a2, a4, a3

	bnez a2, FACTEUR_AGGRANDISSEMENT_ERREUR

	# Sauvegarder les dimensions originales
	ori a3, s2, 0				# Length original
	ori a2, s4, 0				# Width original

	# Recalculer et stocker les nouvelles dimensions de l'image output et leur taille
	mul s2, s2, a4
	mul s4, s4, a4

	ori t0, zero, 0			# Compteur lignes : y = 0

LOOP_HOM_Y:

	beq t0, s4, END_HOM_LOOP		# Fin du tableau ?

	ori t1, zero, 0			# Compteur colonnes : x = 0

LOOP_HOM_X:

	beq t1, s2, NEXT_LINE_HOM		# Fin de la ligne ?

	# Source_x = x // facteur
	div t2, t1, a4

	# Source_y = y // facteur
	div t3, t0, a4

	# Position_pixel_source = (source_y * Length + source_x)
	addi t4, a3, 1			# Ajouter 1 pour le '\n' à la fin de chaque ligne
	mul t4, t3, t4
	add t4, t4, t2

COPY_PIXEL_HOM:

	add t4, s0, t4

	# Charger le bon pixel et le stocker au bon endroit
	lb t6, 0(t4)
	sb t6, 0(a1)

	j NEXT_PIXEL_HOM

NEXT_PIXEL_HOM:

	addi a1, a1, 1			# Compteur stockage + 1
	addi a5, a5, 1			# Compteur taille OutputBuffer + 1
	addi t1, t1, 1			# Compteur colonne + 1

	j LOOP_HOM_X

NEXT_LINE_HOM:

	addi t0, t0, 1			# Compteur ligne + 1

	# Stocker '\n' dans le OutputBuffer
	ori t6, zero, '\n'
	sb t6, 0(a1)

	addi a1, a1, 1			# Compteur stockage + 1
	addi a5, a5, 1			# Compteur taille OutputBuffer + 1

	j LOOP_HOM_Y

END_HOM_LOOP:

	# Afficher le nouveau contenu de OutputBuffer
	ori a7, zero, 4
	la a0, OutputBufferMsg
	ecall

	ori a7, zero, 4
	ori a0, a6, 0
	ecall

	# Afficher la taille
	ori a7, zero, 4
	la a0, OutputBufferSizeMsg
	ecall

	ori a7, zero, 1
	ori a0, a5, 0
	ecall

	jal ra, WRITE_ENTER

	# Epilogue
	lw ra, 0(sp)
	addi sp, sp, 16

	# Retour à main
	jalr zero, 0(ra)

FACTEUR_AGGRANDISSEMENT_ERREUR:

	ori a7, zero, 4
	la a0, FacteurAggrandissementErreurMsg
	ecall

	j EXIT

ERR_TYPE_OPE:

	ori a7, zero, 4
	la a0, OperErr
	ecall

	j EXIT

TRANSLATION:

	la a6, OutputBuffer			# Buffer où écrire le nouveau contenu (sans header)
	ori a2, a6, 0				# Buffer pour écrire le contenu sans toucher à a6 qui pointe au début de ce Buffer
	ori a5, zero, 0			# Sauvegarder le compteur taille de OutputBuffer

	ori t0, zero, 0			# Compteur lignes : y = 0

LOOP_TRANSL_Y:

	beq t0, s4, END_TRANSLATION_LOOP	# Fin du tableau ?

	ori t1, zero, 0			# Compteur colonnes : x = 0

LOOP_TRANSL_X:

	beq t1, s2, NEXT_LINE_TRANSL	# Fin de la ligne ?

	# Source_x = x - dx
	sub t2, t1, a4
	blt t2, zero, BLANK_PIXEL_TRANSL
	bge t2, s2, BLANK_PIXEL_TRANSL

	# Source_y = y + dy
	add t3, t0, a3
	blt t3, zero, BLANK_PIXEL_TRANSL
	bge t3, s4, BLANK_PIXEL_TRANSL

	# position_pixel_source = (source_y * Length + source_x)
	addi t4, s2, 1			# Ajouter 1 pour le '\n' à la fin de chaque ligne
	mul t4, t3, t4
	add t4, t4, t2

COPY_PIXEL_TRANSL:

	add t5, s0, t4

	# Charger le bon pixel et le stocker au bon endroit
	lb t6, 0(t5)
	sb t6, 0(a2)

	j NEXT_PIXEL_TRANSL

BLANK_PIXEL_TRANSL:

	ori t6, zero, ' '			# Caractère du fond d'image
	sb t6, 0(a2)

	j NEXT_PIXEL_TRANSL

NEXT_PIXEL_TRANSL:

	addi a2, a2, 1			# Compteur stockage + 1
	addi a5, a5, 1			# Compteur taille OutputBuffer + 1
	addi t1, t1, 1			# Compteur colonne + 1

	j LOOP_TRANSL_X

NEXT_LINE_TRANSL:

	addi t0, t0, 1			# Compteur ligne + 1

	# Stocker '\n' dans le OutputBuffer
	ori t6, zero, '\n'
	sb t6, 0(a2)

	addi a2, a2, 1			# Compteur stockage + 1
	addi a5, a5, 1			# Compteur taille OutputBuffer + 1

	j LOOP_TRANSL_Y

END_TRANSLATION_LOOP:

	# Afficher le nouveau contenu de OutputBuffer
	ori a7, zero, 4
	la a0, OutputBufferMsg
	ecall

	ori a7, zero, 4
	ori a0, a6, 0
	ecall

	# Afficher la taille
	ori a7, zero, 4
	la a0, OutputBufferSizeMsg
	ecall

	ori a7, zero, 1
	ori a0, a5, 0
	ecall

	jal ra, WRITE_ENTER

	# Epilogue
	lw ra, 0(sp)
	addi sp, sp, 16

	# Retour à main
	jalr zero, 0(ra)

WRITE_OUTPUT:

	# Prologue
	addi sp, sp, -16
	sw ra, 0(sp)

	# Convertir les dimensions en chaînes
	# Length
	la a1, LengthStr
	ori a0, s2, 0
	jal ra, INT_TO_STR
	ori s3, a0, 0

	# Width
	la a1, WidthStr
	ori a0, s4, 0
	jal ra, INT_TO_STR
    	ori s5, a0, 0

    	# NbCol
	la a1, NbColStr
	ori a0, s6, 0
	jal ra, INT_TO_STR
    	ori s7, a0, 0

    	# CarPerPixel
	la a1, CarPerPixelStr
	ori a0, s8, 0
	jal ra, INT_TO_STR
    	ori s9, a0, 0

	# Ouvrir le fichier de sortie en mode écriture (créer ou écraser)
	ori a7, zero, 1024
	la a0, OutputFilePath
	ori a1, zero, 1			# Flags (1 = write-only, create if not exists)
	ecall

	blt a0, zero, OPEN_INPUT_ERROR	# Test erreur d'ouverture
	ori s0, a0, 0				# Sauvegarder le fd de output pour l'écriture

	# Ecrire le format (FormatBuffer)
	ori a7, zero, 64			# Syscall écrire doc
	ori a0, s0, 0				# Descripteur de fichier
	la a1, FormatBuffer			# Adresse du buffer à écrire dans le doc
	ori a2, s1, 0				# Taille des données à écrire dans le doc
	ecall

	# Écrire Length
	ori a7, zero, 64
	ori a0, s0, 0	
	la a1, LengthStr
	ori a2, s3, 0
	ecall

	jal ra, WRITE_SPACE

	# Écrire Width
	ori a7, zero, 64
	ori a0, s0, 0
	la a1, WidthStr
	ori a2, s5, 0
	ecall

	jal ra, WRITE_SPACE

	# Écrire NbCol
	ori a7, zero, 64
	ori a0, s0, 0
	la a1, NbColStr
	ori a2, s7, 0
	ecall

	jal ra, WRITE_SPACE

	# Écrire CarPerPixel
	ori a7, zero, 64
	ori a0, s0, 0
	la a1, CarPerPixelStr
	ori a2, s9, 0
	ecall

	jal ra, WRITE_ENTER

	# Écrire la palette (PaletteBuffer)
	ori a7, zero, 64
	ori a0, s0, 0
	ori a1, s10, 0
	ori a2, s11, 0
	ecall

	# Écrire le contenu translaté
	ori a7, zero, 64
	ori a0, s0, 0
	ori a1, a6, 0
	ori a2, a5, 0
	ecall

	j WRITE_DONE

WRITE_SPACE:

	# Ecrire un espace ' '
	ori a7, zero, 64
	ori a0, s0, 0
	la a1, Space
	ori a2, zero, 1
	ecall

	jalr zero, 0(ra)

WRITE_ENTER:

	# Ecrire un espace ' '
	ori a7, zero, 64
	ori a0, s0, 0
	la a1, Newline
	ori a2, zero, 1
	ecall

	jalr zero, 0(ra)

WRITE_ERROR:

	ori a7, zero, 4			# Syscall print string
	la a0, OutputMsgErr			# Message d'erreur
	ecall

	j EXIT

WRITE_DONE:

	# Fermer le fichier de sortie
	ori a7, zero, 57			# Syscall close
	ori a0, s0, 0				# Descripteur de fichier
	ecall

	lw ra, 0(sp)
	addi sp, sp, 16

    	# Retour à MAIN
	jalr, zero, 0(ra)

INT_TO_STR:

	# Prologue
	addi sp, sp, -20
	sw ra, 16(sp)
	sw s0, 12(sp)
	sw s1, 8(sp)
	sw s2, 4(sp)

	ori s0, a0, 0				# Nombre à convertir
	ori s1, a1, 0				# Adresse du buffer
	ori s2, zero, 0			# Initialiser à 0 la taille de ce qu'on va écrire

	# Gérer le cas 0 spécial :
	# Si l'entrée est zéro, on écrit directement "0\0" dans le buffer
	bnez s0, NOT_ZERO
	ori t0, zero, '0'
	sb t0, 0(s1)
	ori t0, zero, 0
	sb t0, 1(s1)
	addi s2, zero, 1			# Taille = 1 pour "0"

	j INT_TO_STR_END

NOT_ZERO:

	# Trouver la fin du buffer
	addi t1, s1, 12			# On suppose un buffer taille maximale de 12 octets

	# Place le terminateur null à la fin du buffer
	sb zero, 0(t1)
	addi t1, t1, -1

	ori t2, zero, 10			# Base 10

CONVERT_LOOP:

	# Remplir le buffer à partir de la fin
	remu t3, s0, t2			# t3 = s0 % 10
	divu s0, s0, t2			# s0 = s0 / 10
	addi t3, t3, '0'			# Convertir en ASCII le chiffre à écrire
	sb t3, 0(t1)				# Stocker le caractère
	addi t1, t1, -1			# Déplacer le pointeur
	addi s2, s2, 1			# Incrémenter le compteur de taille

	beqz s0, INT_TO_STR_END		# S'arrêter quand le chiffre est inférieur à 10

	j CONVERT_LOOP

INT_TO_STR_END:

	# Déplacer la chaîne au début du buffer
	addi t1, t1, 1
	ori a0, s1, 0
	ori a1, t1, 0
	ori t3, zero, 0			# Réinitialiser t3 pour le décompte

# Déplacer la chaîne résultante au début du buffer
MOVE_LOOP:

	lb t0, 0(t1)
	beqz t0, MOVE_DONE
	sb t0, 0(s1)
	addi s1, s1, 1
	addi t1, t1, 1
	addi t3, t3, 1			# Compter chaque caractère déplacé

	j MOVE_LOOP

MOVE_DONE:

	sb zero, 0(s1)			# Null terminator
	ori a0, s2, 0				# Placer la taille dans a0 pour le retour

	# Épilogue
	lw s2, 4(sp)
	lw s1, 8(sp)
	lw s0, 12(sp)
	lw ra, 16(sp)
	addi sp, sp, 20

	# Retour à WRITE_OUTPUT
	jalr zero, 0(ra)

EXIT:

	# Quitter
	ori a7, zero, 10
	ecall
