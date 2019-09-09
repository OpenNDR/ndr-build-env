LIB ?= $(NAME)

SRCDIR := $(NBE_ROOT)/$S

.PHONY: build
build: $(OBJLIST) $(PICLIST) $(INCS) lklib

.PHONY: depset
depset: mkdir $(HDRS)

mkdir::
	#Output directories pre-init
	@[ -d $(NBE_MK_OBJPATH) ] || mkdir -p $(NBE_MK_OBJPATH)
	@[ -d $(NBE_INCPATH) ] || mkdir -p $(NBE_INCPATH)
	@[ -d $(NBE_LIBPATH) ] || mkdir -p $(NBE_LIBPATH)

$(OBJLIST)::
	$(eval LNKLIST += $(wildcard $(NBE_MK_OBJPATH)/$@/*.o))

$(PICLIST)::
	$(eval LNKLIST += $(wildcard $(NBE_MK_PICPATH)/$@/*.o))

$(INCS)::
	@cp -f $(SRCDIR)/$@ $(NBE_INCPATH)

lklib::
	@ar rcs $(NBE_LIBPATH)/lib$(LIB).a $(LNKLIST)
