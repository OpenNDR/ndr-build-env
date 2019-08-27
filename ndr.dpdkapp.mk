SRCDIR := $(NBE_ROOT)/$S
LDFLAGS += --as-needed -ldl

.PHONY: build
build: $(DEPLIBS) $(EXTOBJS) $(SRCS) lkapp mvapp

.PHONY: depset
depset: mkdir $(HDRS)

mkdir::
	#Output directories pre-init
	@[ -d $(NBE_MK_INCPATH) ] || mkdir -p $(NBE_MK_INCPATH)
	@[ -d $(NBE_MK_OBJPATH) ] || mkdir -p $(NBE_MK_OBJPATH)
	@[ -d $(NBE_MK_DPDKPATH) ] || mkdir -p $(NBE_MK_DPDKPATH)
	@[ -d $(NBE_INCPATH) ] || mkdir -p $(NBE_INCPATH)
	@[ -d $(NBE_LIBPATH) ] || mkdir -p $(NBE_LIBPATH)
	@[ -d $(NBE_APPPATH) ] || mkdir -p $(NBE_APPPATH)

$(HDRS)::
	@echo $@:$(SRCDIR):$(NBE_MK_INCPATH) >> $(NBE_LOG_PATHLOG)
	@cp -f $(SRCDIR)/$@ $(NBE_MK_INCPATH)

$(DEPLIBS):
	$(eval LIBLIST += $(addprefix -l,$@))

$(EXTOBJS):
	$(eval EXTLIST += $(wildcard  $(NBE_MK_OBJPATH)/$@/*.o))

$(SRCS)::
	@[ -d $(NBE_DPDKPATH) ] && cp -Lr $(NBE_DPDKPATH)/include/* $(NBE_MK_DPDKPATH)/.
	@gcc -c $(SRCDIR)/$@ -I$(NBE_INCPATH) -I$(NBE_MK_DPDKPATH) -I$(NBE_MK_INCPATH) $(CFLAGS) $(EXTRA_CFLAGS)
	@cp -f $(basename $@).o  $(NBE_MK_OBJPATH)
	$(eval SRCLIST += $(basename $@).o)

lkapp:
	@[ -d $(NBE_DPDKPATH) ] && cp -Lr $(NBE_DPDKPATH)/lib/* $(NBE_MK_DPDKPATH)/.
	@gcc -o $(DPDKAPP).app $(EXTLIST) $(SRCLIST) -L$(NBE_LIBPATH) -L$(NBE_MK_DPDKPATH) $(NBE_LIBS) $(NBE_DPDKLIBS) $(LIBLIST)

mvapp:
	@mv -f $(DPDKAPP).app $(NBE_APPPATH)
