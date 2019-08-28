SRCDIR := $(NBE_ROOT)/$S

.PHONY: build
build: $(EXTOBJS) $(SRCS) $(INCS) lklib

.PHONY: depset
depset: mkdir $(HDRS)

mkdir::
	#Output directories pre-init
	@[ -d $(NBE_MK_INCPATH) ] || mkdir -p $(NBE_MK_INCPATH)
	@[ -d $(NBE_MK_LOBJPATH) ] || mkdir -p $(NBE_MK_LOBJPATH)
	@[ -d $(NBE_INCPATH) ] || mkdir -p $(NBE_INCPATH)
	@[ -d $(NBE_LIBPATH) ] || mkdir -p $(NBE_LIBPATH)

$(HDRS)::
	@echo $@:$(SRCDIR):$(NBE_MK_INCPATH) >> $(NBE_LOG_PATHLOG)
	@cp -f $(SRCDIR)/$@ $(NBE_MK_INCPATH)

$(EXTOBJS)::
	$(eval LNKLIST += $(wildcard $(NBE_MK_OBJPATH)/$@/*.o))

$(SRCS)::
	$(eval LIBDEFS += $(foreach LIBFLAG, $(LIBFLAGS), $(addprefix -D,$(LIBFLAG))))
	@gcc -c $(SRCDIR)/$@ -I$(NBE_INCPATH) -I$(NBE_MK_INCPATH) $(CFLAGS) $(EXTRA_CFLAGS) $(LIBDEFS)
	@cp -f $(basename $@).o $(NBE_MK_LOBJPATH)
	$(eval LNKLIST += $(basename $@).o)

$(INCS)::
	@cp -f $(SRCDIR)/$@ $(NBE_INCPATH)

lklib::
	@ar rcs $(NBE_LIBPATH)/lib$(LIB).a $(LNKLIST)
