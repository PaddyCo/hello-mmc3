TITLE = hello-world
VERSION = 0.1

# Assembly files to compile
PRG_ASM = main mmc3 test init ppu
INC_FILES = common

# Directories
OBJ_DIR = obj
OUT_DIR = out
SRC_DIR = src

# Tools
MKDIR_P = mkdir -p
CA65 = ca65
LD65 = ld65
EMU ?= fceux

# Build Targets
all: directories rom

## Directories
$(OBJ_DIR):
	${MKDIR_P} ${OBJ_DIR}
$(OUT_DIR):
	${MKDIR_P} ${OUT_DIR}

directories: $(OBJ_DIR) $(OUT_DIR)

## Rom 
rom: $(TITLE).nes

PRG_OBJ = $(foreach o,$(PRG_ASM),$(OBJ_DIR)/$(o).o)
INC = $(foreach i,$(INC_FILES),$(SRC_DIR)/$(i).inc)

map.txt $(TITLE).dbg $(TITLE).nes: MMC3.cfg $(PRG_OBJ)
	$(LD65) $(PRG_OBJ) -o $(OUT_DIR)/$(TITLE).nes -C MMC3.cfg -m $(OUT_DIR)/map.txt --dbgfile $(OUT_DIR)/$(TITLE).dbg

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s $(INC)
	$(CA65) $< -o $@ --debug-info

## Commands
.PHONY: clean directories emu

clean:
	-rm -r $(OBJ_DIR)

emu: $(TITLE).nes
	$(EMU) $(OUT_DIR)/$(TITLE).nes

# everdrive: $(TITLE).nes
# TODO: Implement when I get my NES & Everdrive setup
