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
	@gcc -c $(SRCDIR)/$@ -I$(NBE_INCPATH) -I$(NBE_MK_INCPATH) $(CFLAGS) $(EXTRA_CFLAGS)
	@cp -f $(basename $@).o  $(NBE_MK_OBJPATH)
	$(eval SRCLIST += $(basename $@).o)

lkapp:
	@gcc -o $(APP).app $(EXTLIST) $(SRCLIST) -L$(NBE_LIBPATH) $(NBE_LIBS) $(LIBLIST)

mvapp:
	@mv -f $(APP).app $(NBE_APPPATH)
