OBJ ?= $(NAME)

SRCDIR := $(NBE_ROOT)/$S

.PHONY: build
build: $(ASMS) $(SRCS)

.PHONY: depset
depset: mkdir $(HDRS)

mkdir::
	#Output directories pre-init
	@[ -d $(NBE_MK_INCPATH) ] || mkdir -p $(NBE_MK_INCPATH)
	@[ -d $(NBE_MK_OBJPATH) ] || mkdir -p $(NBE_MK_OBJPATH)
	@[ -d $(NBE_MK_OBJPATH)/$(OBJ) ] || mkdir -p $(NBE_MK_OBJPATH)/$(OBJ)
	@[ -d $(NBE_MK_DPDKPATH) ] || mkdir -p $(NBE_MK_DPDKPATH)
	@[ -d $(NBE_INCPATH) ] || mkdir -p $(NBE_INCPATH)

$(HDRS)::
	@cp -f $(SRCDIR)/$@ $(NBE_MK_INCPATH)

$(ASMS)::
	@[ -d $(NBE_DPDKPATH) ] && cp -Lr $(NBE_DPDKPATH)/include/* $(NBE_MK_DPDKPATH)/.
	@gcc -c $(SRCDIR)/$@ -I$(NBE_INCPATH) -I$(NBE_MK_DPDKPATH) -I$(NBE_MK_INCPATH) $(CFLAGS) $(EXTRA_CFLAGS)
	@cp -f $(basename $@).o $(NBE_MK_OBJPATH)/$(OBJ)

$(SRCS)::
	@[ -d $(NBE_DPDKPATH) ] && cp -Lr $(NBE_DPDKPATH)/include/* $(NBE_MK_DPDKPATH)/.
	@gcc -c $(SRCDIR)/$@ -I$(NBE_INCPATH) -I$(NBE_MK_DPDKPATH) -I$(NBE_MK_INCPATH) $(CFLAGS) $(EXTRA_CFLAGS)
	@cp -f $(basename $@).o $(NBE_MK_OBJPATH)/$(OBJ)
