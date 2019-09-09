$(KEXT) ?= $(NAME)

SRCDIR := $(NBE_ROOT)/$S

.PHONY: build
build: $(SRCS)

.PHONY: depset
depset: mkdir $(HDRS)

mkdir::
	#Output directories pre-init
	@[ -d $(NBE_MK_INCPATH) ] || mkdir -p $(NBE_MK_INCPATH)
	@[ -d $(NBE_MK_KEXTPATH) ] || mkdir -p $(NBE_MK_KEXTPATH)
	@[ -d $(NBE_MK_KEXTPATH)/$(KEXT) ] || mkdir -p $(NBE_MK_KEXTPATH)/$(KEXT)
	@[ -d $(NBE_INCPATH) ] || mkdir -p $(NBE_INCPATH)

$(HDRS)::
	@echo $@:$(SRCDIR):$(NBE_MK_INCPATH) >> $(NBE_LOG_PATHLOG)
	@cp -f $(SRCDIR)/$@ $(NBE_MK_INCPATH)

$(SRCS)::
	@cp -f $(SRCDIR)/$@ $(NBE_MK_KEXTPATH)/$(KEXT)/
