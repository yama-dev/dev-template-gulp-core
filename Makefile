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

build: clean delds transform zip

zip:
	$(CD) $(TEMPLATE_FOLDER) && $(ZIP) master.zip -r .

clean:
	@echo clean
	$(RM) template/master.zip

transform:
	sed -i "" "s/ --develop\"/ --develop --gulpfile node_modules\/@yama-dev\/dev-template-gulp-core\/gulpfile\.esm\.js --cwd \.\/\"/g" "template/package.json"
	sed -i "" "s/ --production\"/ --production --gulpfile node_modules\/@yama-dev\/dev-template-gulp-core\/gulpfile\.esm\.js --cwd \.\/\"/g" "template/package.json"
	sed -i "" -r "s/version\":[ ]?\"[.0-9]*/version\"\: \"${VERSION}/g" "template/package.json"
	sed -i "" -r "s/version\":[ ]?\"[.0-9]*/version\"\: \"${VERSION}/g" "package.json"
	sed -i "" -r "s/yama-dev\/dev-template-gulp-core\.git#v[.0-9]*\"/yama-dev\/dev-template-gulp-core\.git#v${VERSION}\"/g" "template/package.json"

delds:
	find . -name ".DS_Store" -print -exec rm {} ";"

rsync_test:
	@rsync -arhv --checksum --delete --dry-run ../dev-template-gulp/.dev/ ./.dev/
	@rsync -arhv --checksum --delete --dry-run ../dev-template-gulp/package.json ./template/package.json
	@echo '---'
	@echo 'make (dry-run) -> make sync (!important)'
	@echo '---'

rsync:
	@rsync -arhv --checksum --delete ../dev-template-gulp/.dev/ ./.dev/
	@rsync -arhv --checksum --delete ../dev-template-gulp/package.json ./template/package.json
	@echo '---'

backup:
	# $(RM) $(ZIP_FOLDER)
	# $(MK) $(ZIP_FOLDER)
	# $(CP) dist/ $(ZIP_FOLDER)/
	# sed -i "" "s/..\/dist\//.\//g" "$(ZIP_FOLDER)/index.html"
	# $(ZIP) $(ZIP_FOLDER)/$(VERSION).zip -r $(ZIP_FOLDER)/*

.PHONY: all build clean zip
