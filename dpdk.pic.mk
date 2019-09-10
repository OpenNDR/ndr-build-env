PIC ?= $(NAME)

SRCDIR := $(NBE_ROOT)/$S

.PHONY: build
build: $(SRCS)

.PHONY: depset
depset: mkdir $(HDRS)

mkdir::
	#Output directories pre-init
	@[ -d $(NBE_MK_INCPATH) ] || mkdir -p $(NBE_MK_INCPATH)
	@[ -d $(NBE_MK_PICPATH) ] || mkdir -p $(NBE_MK_PICPATH)
	@[ -d $(NBE_MK_DPDKPATH) ] || mkdir -p $(NBE_MK_DPDKPATH)
	@[ -d $(NBE_MK_PICPATH)/$(PIC) ] || mkdir -p $(NBE_MK_PICPATH)/$(PIC)
	@[ -d $(NBE_INCPATH) ] || mkdir -p $(NBE_INCPATH)

$(HDRS)::
	@cp -f $(SRCDIR)/$@ $(NBE_MK_INCPATH)

$(ASMS)::
	@[ -d $(NBE_DPDKPATH) ] && cp -Lr $(NBE_DPDKPATH)/include/* $(NBE_MK_DPDKPATH)/.
	@gcc -c $(SRCDIR)/$@ -I$(NBE_INCPATH) -I$(NBE_MK_DPDKPATH) -I$(NBE_MK_INCPATH) $(CFLAGS) $(EXTRA_CFLAGS) -fPIC -DPIC
	@cp -f $(basename $@).o $(NBE_MK_PICPATH)/$(PIC)

$(SRCS)::
	@[ -d $(NBE_DPDKPATH) ] && cp -Lr $(NBE_DPDKPATH)/include/* $(NBE_MK_DPDKPATH)/.
	@gcc -c $(SRCDIR)/$@ -I$(NBE_INCPATH) -I$(NBE_MK_DPDKPATH) -I$(NBE_MK_INCPATH) $(CFLAGS) $(EXTRA_CFLAGS) -fPIC -DPIC
	@cp -f $(basename $@).o $(NBE_MK_PICPATH)/$(PIC)
