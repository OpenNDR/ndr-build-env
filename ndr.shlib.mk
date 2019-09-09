SHLIB ?= $(NAME)

SRCDIR := $(NBE_ROOT)/$S

.PHONY: build
build: $(LIBLIST) $(OBJLIST) $(PICLIST) $(INCS) lklib

.PHONY: depset
depset: mkdir $(HDRS)

mkdir:
	#Output directories pre-init
	@[ -d $(NBE_MK_OBJPATH) ] || mkdir -p $(NBE_MK_LOBJPATH)
	@[ -d $(NBE_INCPATH) ] || mkdir -p $(NBE_INCPATH)
	@[ -d $(NBE_LIBPATH) ] || mkdir -p $(NBE_LIBPATH)

$(LIBLIST):
	$(eval LIBFLAG += $(addprefix -l,$@))

$(OBJLIST):
	$(eval LNKLIST += $(wildcard $(NBE_MK_OBJPATH)/$@/*.o))

$(PICLIST)::
	$(eval LNKLIST += $(wildcard $(NBE_MK_PICPATH)/$@/*.o))

$(INCS):
	@cp -f $(SRCDIR)/$@ $(NBE_INCPATH)

lklib:
	@gcc -o lib$(SHLIB).so $(LNKLIST) -L$(NBE_LIBPATH) $(NBE_LIBS) $(LIBFLAG) -shared

cplib:
	@cp -f lib$(SHLIB).so $(NBE_LIBPATH)
