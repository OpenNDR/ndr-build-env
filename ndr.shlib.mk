SHLIB ?= $(NAME)

SRCDIR := $(NBE_ROOT)/$S

.PHONY: build
build: $(DEPLIBS) $(EXTOBJS) $(SRCS) $(INCS) lklib

.PHONY: depset
depset: mkdir $(HDRS)

mkdir:
	#Output directories pre-init
	@[ -d $(NBE_MK_INCPATH) ] || mkdir -p $(NBE_MK_INCPATH)
	@[ -d $(NBE_MK_LOBJPATH) ] || mkdir -p $(NBE_MK_LOBJPATH)
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
	$(eval LIBDEFS += $(foreach LIBFLAG, $(LIBFLAGS), $(addprefix -D,$(LIBFLAG))))
	@gcc -c $(SRCDIR)/$@ -I$(NBE_INCPATH) -I$(NBE_MK_INCPATH) $(CFLAGS) $(EXTRA_CFLAGS)
	@cp -f $(basename $@).o $(NBE_MK_LOBJPATH)
	$(eval SRCLIST += $(basename $@).o)

$(INCS):
	@cp -f $(SRCDIR)/$@ $(NBE_INCPATH)

lklib:
	@gcc -o lib$(SHLIB).so $(EXTLIST) $(SRCLIST) -L$(NBE_LIBPATH) $(NBE_LIBS) $(LIBLIST) -shared -fPIC -DPIC

cplib:
	@cp -f lib$(SHLIB).so $(NBE_LIBPATH)
