SHELL = /bin/bash
NODE_BINDIR = ./node_modules/.bin
export PATH := $(NODE_BINDIR):$(PATH)
LOGNAME ?= smm
TEMPLATE_POT ?= ./tmp/template-$(LOGNAME).pot
INPUT_FILES = ./pages ./components ./mixins ./layouts ./const ./store
OUTPUT_DIR = ./app
OUTPUT_SUB_DIR = locale
LOCALES = ru en es pt tr de it
LOCALE_FILES ?= $(patsubst %, $(OUTPUT_DIR)/locale/%/LC_MESSAGES/app.po, $(LOCALES))
GETTEXT_SOURCES ?= $(shell find $(INPUT_FILES) -name '*.js' -o -name '*.vue' 2> /dev/null)

all:
	@echo choose action from: clean extract generate

clean:
	rm -f $(TEMPLATE_POT) $(OUTPUT_DIR)/$(OUTPUT_SUB_DIR)/translations.json

extract: $(TEMPLATE_POT)

generate: ./$(OUTPUT_DIR)/translations.json

$(TEMPLATE_POT): $(GETTEXT_SOURCES)
	mkdir -p $(dir $@)
	gettext-extract --quiet --attribute v-translate --output $@ $(GETTEXT_SOURCES)

	@for lang in $(LOCALES); do \
		export PO_FILE=$(OUTPUT_DIR)/locale/$$lang/LC_MESSAGES/app.po; \
		mkdir -p $$(dirname $$PO_FILE); \
		if [ -f $$PO_FILE ]; then  \
			echo "msgmerge --update $$PO_FILE $@"; \
			msgmerge --lang=$$lang --update $$PO_FILE $@ || break ;\
		else \
			msginit --no-translator --locale=$$lang --input=$@ --output-file=$$PO_FILE || break ; \
			msgattrib --no-wrap --no-obsolete -o $$PO_FILE $$PO_FILE || break; \
		fi; \
	done;

$(OUTPUT_DIR)/translations.json: $(LOCALE_FILES)
	mkdir -p $(OUTPUT_DIR)
	gettext-compile --output $(OUTPUT_DIR)/$(OUTPUT_SUB_DIR)/translations.json $(LOCALE_FILES)
