SRCDIR := $(NBE_ROOT)/$S
DEPSET_DIRS := $(addsuffix _depset,$(DIRS))

.PHONY: build
build: $(DIRS)

.PHONY: depset
depset: $(DEPSET_DIRS)

.PHONY: $(DIRS)
$(DIRS):
	@[ -d $(CURDIR)/$@ ] || mkdir -p $(CURDIR)/$@
	@echo "== Build $S/$@"
	@$(MAKE) S=$S/$@ -f $(SRCDIR)/$@/Makefile -C $(CURDIR)/$@ build

%_depset:
	@echo "== Depset $S/$*"
	@$(MAKE) S=$S/$* -f $(SRCDIR)/$*/Makefile depset