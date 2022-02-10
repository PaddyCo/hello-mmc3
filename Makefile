.PHONY: clean directories emu

TITLE = $(notdir $(CURDIR))
VERSION = 0.1

# Directories
OBJ_DIR = obj
OUT_DIR = out
SRC_DIR = src

# Assembly files to compile
PRG_ASM = $(wildcard $(SRC_DIR)/*.s)
PRG_OBJ := \
  $(patsubst $(SRC_DIR)/%.s,$(OBJ_DIR)/%.o,$(PRG_ASM)) \

# Tools
MKDIR_P = mkdir -p
CA65 = ca65
LD65 = ld65
EMU ?= mesen
EDLINK ?= edlink-n8

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

map.txt $(TITLE).dbg $(TITLE).nes: MMC3.cfg $(PRG_OBJ)
	$(LD65) $(PRG_OBJ) -o $(OUT_DIR)/$(TITLE).nes -C MMC3.cfg -m $(OUT_DIR)/map.txt --dbgfile $(OUT_DIR)/$(TITLE).dbg

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.s
	$(CA65) -o $@ $< --debug-info

## Commands

clean:
	-rm -r $(OBJ_DIR)

emu: $(TITLE).nes
	$(EMU) $(OUT_DIR)/$(TITLE).nes

ed: $(TITLE).nes
	$(EDLINK) $(OUT_DIR)/$(TITLE).nes
