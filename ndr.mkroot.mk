NBE_ROOT = $(CURDIR)
export NBE_ROOT
NBE_DIR = $(NBE_ROOT)/ndr-build-env
export NBE_DIR
NBE_SCRIPTS = $(NBE_DIR)/ndr.build.script
export NBE_SCRIPTS

include $(NBE_DIR)/ndr.pathconf.mk
include $(NBE_DIR)/ndr.dpdkconf.mk
include $(NBE_DIR)/ndr.libconf.mk
include $(NBE_DIR)/ndr.archtype.mk
include $(NBE_DIR)/ndr.defset.mk

export CFLAGS

DEPSET_RDIRS = $(addsuffix _depset,$(RDIRS))

.PHONY: default
default: clean depset build

.PHONY: build
build: $(RDIRS)
	@echo "Build complete [$(PROJECT_NAME)]"

.PHONY: depset
depset: $(DEPSET_RDIRS)
	@echo "Prepare dependency complete [$(PROJECT_NAME)]"

.PHONY: clean
clean:
	@if ! [ "$(NBE_OUTPUT)" = "" ]; then \
		rm -rf $(NBE_OUTPUT); \
	fi
	@echo "Clean complete [$(PROJECT_NAME)]"

.PHONY: $(RDIRS)
$(RDIRS)::
	@echo "== Build $@"
	@$(MAKE) S=$@ -f $(NBE_ROOT)/$@/Makefile -C $(NBE_BUILDPATH)/$@ build

%_depset::
	@[ -d $(NBE_OUTPUT)/$* ] || mkdir -p $(NBE_BUILDPATH)/$*
	@echo "== Depset $*"
	@$(MAKE) S=$* -f $(NBE_ROOT)/$*/Makefile depset
