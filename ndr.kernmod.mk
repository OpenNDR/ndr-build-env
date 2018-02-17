SRCDIR := $(NBE_ROOT)/$S

KVER ?= $(shell uname -r)
KDIR := /lib/modules/$(KVER)/build
EXTRA_CFLAGS += -I$(NBE_MK_INCPATH)
obj-m := $(KMOD).o
$(KMOD)-objs := $(SRCS:.c=.o) $(ASMS:.S=.o)

.PHONY: build
build: $(HDRS) mkkmod mvkmod

.PHONY: depset
depset: mkdir $(HDRS)

mkdir:
	#Output directories pre-init
	@[ -d $(NBE_MK_INCPATH) ] || mkdir -p $(NBE_MK_INCPATH)
	@[ -d $(NBE_MK_KBUILDPATH) ] || mkdir -p $(NBE_MK_KBUILDPATH)
	@[ -d $(NBE_KMODPATH) ] || mkdir -p $(NBE_KMODPATH)

$(HDRS):
	@cp -f $(SRCDIR)/$@ $(NBE_MK_INCPATH)

mkkmod:
	@cp -r $(SRCDIR) $(NBE_MK_KBUILDPATH)/$(KMOD)
	$(MAKE) -C $(KDIR) M=$(NBE_MK_KBUILDPATH)/$(KMOD) modules
	@ln -s $(NBE_MK_KBUILDPATH)/$(KMOD) kbuilt-$(KMOD)

mvkmod:
	@mv -f $(NBE_MK_KBUILDPATH)/$(KMOD)/$(KMOD).ko $(NBE_KMODPATH)