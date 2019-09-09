DPDKSHL ?= $(NAME)

SRCDIR := $(NBE_ROOT)/$S

.PHONY: build
build: $(LIBLIST) $(OBJLIST) $(PICLIST) $(INCS) lklib

.PHONY: depset
depset: mkdir $(HDRS)

mkdir:
	#Output directories pre-init
	@[ -d $(NBE_MK_INCPATH) ] || mkdir -p $(NBE_MK_INCPATH)
	@[ -d $(NBE_MK_DPDKPATH) ] || mkdir -p $(NBE_MK_DPDKPATH)
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
	@[ -d $(NBE_DPDKPATH) ] && cp -Lr $(NBE_DPDKPATH)/lib/* $(NBE_MK_DPDKPATH)/.
	@gcc -o lib$(DPDKSHL).so $(LNKLIST) $(SRCLIST) -L$(NBE_LIBPATH) -L$(NBE_MK_DPDKPATH) $(NBE_LIBS) $(NBE_DPDKLIBS) $(LIBFLAG) -shared

cplib:
	@cp -f lib$(DPDKSHL).so $(NBE_LIBPATH)
