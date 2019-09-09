KMOD ?= $(NAME)

SRCDIR := $(NBE_ROOT)/$S

KVER ?= $(shell uname -r)
KDIR := /lib/modules/$(KVER)/build
EXTRA_CFLAGS += -I$(NBE_MK_INCPATH)
obj-m := $(KMOD).o
ifneq ($(origin KEXTS), undefined)
	KEXT_DIRS += $(foreach KEXT_ITER, $(KEXTS), $(NBE_MK_KEXTPATH)/$(KEXT_ITER)/)
	KEXT_SRCS += $(foreach KEXT_ITER, $(KEXT_DIRS), $(shell ls $(KEXT_ITER)))
	SRCS_ORG := $(SRCS)
	SRCS = $(KEXT_SRCS)
	SRCS += $(SRCS_ORG)
endif
SRCS_C := $(SRCS:.c=.o)
SRCS_CC := $(SRCS_C:.cc=.o)
$(KMOD)-objs := $(SRCS_CC) $(ASMS:.S=.o)

.PHONY: build
build: $(KEXTS) mkkmod cpkmod

.PHONY: depset
depset: mkdir $(HDRS)

mkdir::
	#Output directories pre-init
	@[ -d $(NBE_MK_INCPATH) ] || mkdir -p $(NBE_MK_INCPATH)
	@[ -d $(NBE_MK_KBUILDPATH) ] || mkdir -p $(NBE_MK_KBUILDPATH)
	@[ -d $(NBE_KMODPATH) ] || mkdir -p $(NBE_KMODPATH)

$(HDRS)::
	@echo $@:$(SRCDIR):$(NBE_MK_INCPATH) >> $(NBE_LOG_PATHLOG)
	@cp -f $(SRCDIR)/$@ $(NBE_MK_INCPATH)

$(KEXTS)::
	@[ -d $(NBE_MK_KBUILDPATH)/$(KMOD) ] || mkdir -p $(NBE_MK_KBUILDPATH)/$(KMOD)
	@cp -f $(NBE_MK_KEXTPATH)/$@/* $(NBE_MK_KBUILDPATH)/$(KMOD)

mkkmod::
	@[ -d $(NBE_MK_KBUILDPATH)/$(KMOD) ] || mkdir -p $(NBE_MK_KBUILDPATH)/$(KMOD)
	@cp -rf $(SRCDIR)/* $(NBE_MK_KBUILDPATH)/$(KMOD)
	$(MAKE) -C $(KDIR) M=$(NBE_MK_KBUILDPATH)/$(KMOD) modules
	@ln -s $(NBE_MK_KBUILDPATH)/$(KMOD) kbuilt-$(KMOD)

cpkmod::
	@cp -f $(NBE_MK_KBUILDPATH)/$(KMOD)/$(KMOD).ko $(NBE_KMODPATH)
