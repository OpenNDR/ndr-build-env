SRCDIR := $(NBE_ROOT)/$S

KVER ?= $(shell uname -r)
KDIR := /lib/modules/$(KVER)/build
EXTRA_CFLAGS += -I$(NBE_MK_INCPATH)
obj-m := $(KMOD).o
SRCS_EXT_C := $(SRCS:.c=.o)
SRCS_EXT_CC := $(SRCS_EXT_C:.cc=.o)
$(KMOD)-objs := $(SRCS_EXT_CC) $(ASMS:.S=.o)

.PHONY: build
build: $(SRCS) mkkmod mvkmod

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

$(SRCS):: ;

mkkmod:
	@cp -r $(SRCDIR) $(NBE_MK_KBUILDPATH)/$(KMOD)
	$(MAKE) -C $(KDIR) M=$(NBE_MK_KBUILDPATH)/$(KMOD) modules
	@ln -s $(NBE_MK_KBUILDPATH)/$(KMOD) kbuilt-$(KMOD)

mvkmod:
	@mv -f $(NBE_MK_KBUILDPATH)/$(KMOD)/$(KMOD).ko $(NBE_KMODPATH)