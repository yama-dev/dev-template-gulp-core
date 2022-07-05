include .env

VIM := nvim

PROGRAM := npm
RM := rm -rf
MK := mkdir
CP := cp
CD := cd
ZIP := zip

ZIP_FOLDER := _v$(VERSION)
TEMPLATE_FOLDER := template

ENV_DEV := NODE_ENV=development
ENV_PROD := NODE_ENV=production

# DIRECTORIES = $(wildcard ./template/*/)

DIRS := $(shell cd ./template && find . -type d -mindepth 1 -maxdepth 1)

all:
	@for i in $(DIRS) ; do \
		echo $$i ; \
	done

build: clean

clean:
	@echo clean
	$(RM) dist

transform:
	sed -i "" "s/..\/dist\//.\//g" "$(ZIP_FOLDER)/index.html"

delds:
	find . -name ".DS_Store" -print -exec rm {} ";"

zip: delds
	$(CD) $(TEMPLATE_FOLDER) && $(ZIP) master.zip -r .

make:
	# $(RM) $(ZIP_FOLDER)
	# $(MK) $(ZIP_FOLDER)
	# $(CP) dist/ $(ZIP_FOLDER)/
	# sed -i "" "s/..\/dist\//.\//g" "$(ZIP_FOLDER)/index.html"
	# $(ZIP) $(ZIP_FOLDER)/$(VERSION).zip -r $(ZIP_FOLDER)/*

.PHONY: all build clean zip
