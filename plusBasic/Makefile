# Build plusBASIC system ROM (zout/sysrom.bin) and PT3 player (zout/ptplay.bin)
#
#   make              build sysrom.bin and ptplay.bin
#   make sysrom       build sysrom.bin only
#   make ptplay       build ptplay.bin only
#   make DEFINE=FOO   pass -DFOO to zmac (same as "build.bat FOO")
#   make clean        remove generated files

ZMAC    ?= zmac
DEFINE  ?=
ZFLAGS  := --zmac -c -n $(if $(DEFINE),-D$(DEFINE))
INCDIRS := -I auxrom -I basic -I gfxrom

SYSROM  := zout/sysrom.bin
PTPLAY  := zout/ptplay.bin

SYSROM_DEPS := aqplusbas.asm $(wildcard *.asm *.inc auxrom/*.asm auxrom/*.inc \
                 basic/*.asm basic/*.inc gfxrom/*.asm gfxrom/*.inc)
PTPLAY_DEPS := $(wildcard pt3player/*.asm pt3player/*.i)

.PHONY: all sysrom ptplay clean

all: sysrom ptplay

sysrom: $(SYSROM)
ptplay: $(PTPLAY)

zout/aqplusbas.cim: $(SYSROM_DEPS)
	$(ZMAC) $(ZFLAGS) aqplusbas.asm $(INCDIRS) --oo cim,lst

$(SYSROM): zout/aqplusbas.cim
	cp $< $@

pt3player/zout/main.cim: $(PTPLAY_DEPS)
	cd pt3player && $(ZMAC) --zmac --oo cim,lst -L -n main.asm

$(PTPLAY): pt3player/zout/main.cim
	mkdir -p zout
	cp $< $@

clean:
	rm -f zout/aqplusbas.cim zout/aqplusbas.lst \
	      pt3player/zout/main.cim pt3player/zout/main.lst
