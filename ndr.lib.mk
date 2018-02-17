SRCDIR := $(NBE_ROOT)/$S

.PHONY: build
build: $(HDRS) $(EXTOBJS) $(SRCS) lklib

.PHONY: depset
depset: mkdir $(HDRS)

mkdir:
	#Output directories pre-init
	@[ -d $(NBE_INCPATH) ] || mkdir -p $(NBE_INCPATH)
	@[ -d $(NBE_MK_INCPATH) ] || mkdir -p $(NBE_MK_INCPATH)
	@[ -d $(NBE_MK_LOBJPATH) ] || mkdir -p $(NBE_MK_LOBJPATH)
	@[ -d $(NBE_LIBPATH) ] || mkdir -p $(NBE_LIBPATH)

$(HDRS):
	@cp -f $(SRCDIR)/$@ $(NBE_OUTPUT)/include

$(EXTOBJS):
	$(eval LNKLIST += $(wildcard  $(NBE_MK_OBJPATH)/$@/*.o))

$(SRCS):
	@gcc -c $(SRCDIR)/$@ -I$(NBE_INCPATH) -I$(NBE_MK_INCPATH) $(CFLAGS) $(EXTRA_CFLAGS)
	@cp -f $(basename $@).o $(NBE_MK_LOBJPATH)
	$(eval LNKLIST += $(basename $@).o)

lklib:
	@ar rcs $(NBE_LIBPATH)/lib$(LIB).a $(LNKLIST)