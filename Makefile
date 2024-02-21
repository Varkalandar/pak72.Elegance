
MAKEOBJ ?= ./makeobj
#MAKEOBJ ?= ./makepak

DESTDIR  ?= ./
PAKDIR   ?= $(DESTDIR)/pak72.Elegance
ADDONDIR ?= $(DESTDIR)/addons/pak72.Elegance
PAKVERSION ?= 07
DESTFILE ?= pak72.Elegance_v0$(PAKVERSION)
INSTALL ?= ~/simutrans/paksets/pak72.Elegance

DIRS64 :=
DIRS64 += src/menu_icons

DIRS72 :=
DIRS72 += src/ground
DIRS72 += src/city
DIRS72 += src/city/residential
DIRS72 += src/city/commercial
DIRS72 += src/city/industrial
DIRS72 += src/city/townhalls
DIRS72 += src/deco
DIRS72 += src/industry
DIRS72 += src/industry/clay
DIRS72 += src/industry/sand
DIRS72 += src/industry/iron
DIRS72 += src/industry/market
DIRS72 += src/player
DIRS72 += src/player/rail
DIRS72 += src/player/road
DIRS72 += src/player/water
DIRS72 += src/sights/city
DIRS72 += src/sights/land
DIRS72 += src/trees
DIRS72 += src/vehicles/rail
DIRS72 += src/vehicles/road
DIRS72 += src/vehicles/water
DIRS72 += src/ways/rails
DIRS72 += src/ways/rails/bridges
DIRS72 += src/ways/roads
DIRS72 += src/ways/roads/bridges
DIRS72 += src/ways/river
DIRS72 += src/ways/maglev

DIRS128 :=
DIRS128 += src/big_logo
DIRS128 += src/sights/land/128

DIRS192 :=
DIRS192 += src/sights/land/192

DIRS := $(DIRS192) $(DIRS64) $(DIRS72) $(DIRS128)

.PHONY: $(DIRS) copy zip

all: version copy $(DIRS) zip

archives: zip

release: clean version copy $(DIRS)
	rm -rf $(INSTALL)
	mkdir -p $(INSTALL)
	mv $(PAKDIR)/* $(INSTALL)
	
zip: $(DESTFILE).zip

$(DESTFILE).zip: $(PAKDIR)
	@echo "===> ZIP $@"
	@zip -rq -9 $@ $(PAKDIR)

copy:
	@echo "===> COPY"
	@mkdir -p $(PAKDIR)/sound $(PAKDIR)/text $(PAKDIR)/config $(PAKDIR)/scenario
	@cp -p src/compat/compat.tab $(PAKDIR)
	@cp -p src/sound/* $(PAKDIR)/sound
	@cp -p src/config/* $(PAKDIR)/config
	@cp -p src/text/* $(PAKDIR)/text

$(DIRS64):
	@echo "===> PAK64 $@"
	@mkdir -p $(PAKDIR)
	@$(MAKEOBJ) quiet PAK64 $(PAKDIR)/ $@/

$(DIRS72):
	@echo "===> PAK72 $@"
	@mkdir -p $(PAKDIR)
	@$(MAKEOBJ) quiet PAK72 $(PAKDIR)/ $@/

$(DIRS128):
	@echo "===> PAK128 $@"
	@mkdir -p $(PAKDIR)
	@$(MAKEOBJ) quiet PAK128 $(PAKDIR)/ $@/ > /dev/null

$(DIRS192):
	@echo "===> PAK192 $@"
	@mkdir -p $(PAKDIR)
	@$(MAKEOBJ) quiet PAK192 $(PAKDIR)/ $@/ > /dev/null

version:
	@echo "===> Version"
	@mkdir -p $(PAKDIR)
	@rm -f src/ground/outside.dat
	@echo "Obj=ground" >src/ground/outside.dat
	@echo "Name=Outside" >>src/ground/outside.dat
	@echo "copyright=pak72.Elegance v0.$(PAKVERSION)" >>src/ground/outside.dat
	@echo "Image[0][0]=hjm-outside.0.0" >>src/ground/outside.dat
	@echo "----------" >>src/ground/outside.dat
	@echo "$(PAKVERSION)" >version.txt

clean:
	@echo "===> CLEAN"
	@rm -fr $(PAKDIR) $(DESTFILE).tbz2 $(DESTFILE).zip
