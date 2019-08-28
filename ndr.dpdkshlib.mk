SRCDIR := $(NBE_ROOT)/$S

.PHONY: build
build: $(DEPLIBS) $(EXTOBJS) $(SRCS) $(INCS) lklib

.PHONY: depset
depset: mkdir $(HDRS)

mkdir:
	#Output directories pre-init
	@[ -d $(NBE_MK_INCPATH) ] || mkdir -p $(NBE_MK_INCPATH)
	@[ -d $(NBE_MK_LOBJPATH) ] || mkdir -p $(NBE_MK_LOBJPATH)
	@[ -d $(NBE_MK_DPDKPATH) ] || mkdir -p $(NBE_MK_DPDKPATH)
	@[ -d $(NBE_INCPATH) ] || mkdir -p $(NBE_INCPATH)
	@[ -d $(NBE_LIBPATH) ] || mkdir -p $(NBE_LIBPATH)

$(HDRS):
	@echo $@:$(SRCDIR):$(NBE_MK_INCPATH) >> $(NBE_LOG_PATHLOG)
	@cp -f $(SRCDIR)/$@ $(NBE_MK_INCPATH)

$(DEPLIBS):
	$(eval LIBLIST += $(addprefix -l,$@))

$(EXTOBJS):
	$(eval EXTLIST += $(wildcard $(NBE_MK_OBJPATH)/$@/*.o))

$(SRCS):
	@[ -d $(NBE_DPDKPATH) ] && cp -Lr $(NBE_DPDKPATH)/include/* $(NBE_MK_DPDKPATH)/.
	$(eval LIBDEFS += $(foreach LIBFLAG, $(LIBFLAGS), $(addprefix -D,$(LIBFLAG))))
	@gcc -c $(SRCDIR)/$@ -I$(NBE_INCPATH) -I$(NBE_MK_DPDKPATH) -I$(NBE_MK_INCPATH) $(CFLAGS) $(EXTRA_CFLAGS)
	@cp -f $(basename $@).o $(NBE_MK_LOBJPATH)
	$(eval SRCLIST += $(basename $@).o)

$(INCS):
	@cp -f $(SRCDIR)/$@ $(NBE_INCPATH)

lklib:
	@[ -d $(NBE_DPDKPATH) ] && cp -Lr $(NBE_DPDKPATH)/lib/* $(NBE_MK_DPDKPATH)/.
	@gcc -o lib$(SHLIB).so $(EXTLIST) $(SRCLIST) -L$(NBE_LIBPATH) -L$(NBE_MK_DPDKPATH) $(NBE_LIBS) $(NBE_DPDKLIBS) $(LIBLIST) -shared -fPIC -DPIC

cplib:
	@cp -f lib$(SHLIB).so $(NBE_LIBPATH)
