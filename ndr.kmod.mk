KMOD ?= $(NAME)

SRCDIR := $(NBE_ROOT)/$S

KVER ?= $(shell uname -r)
KDIR := /lib/modules/$(KVER)/build
EXTRA_CFLAGS += -I$(NBE_MK_INCPATH)
obj-m := $(KMOD).o
ifneq ($(origin KEXTS), undefined)
	KEXT_DIRS += $(foreach KEXT_ITER, $(KEXTS), $(NBE_MK_KEXTPATH)/$(KEXT_ITER)/)
	KEXT_FILES += $(foreach KEXT_ITER, $(KEXT_DIRS), $(shell ls $(KEXT_ITER)))
	FILES_ORG := $(SRCS)
	FILES_ORG += $(ASMS)
	FILES = $(KEXT_FILES)
	FILES += $(FILES_ORG)
endif
SRCS_C := $(FILES:.c=.o)
SRCS_CC := $(FILES:.cc=.o)
ASMS_S := $(FILES:.s=.o)
ASMS_ASM := $(FILES:.asm=.o)
$(KMOD)-objs := $(SRCS_C) $(SRCS_CC) $(ASMS_S) $(ASMS_ASM)

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
