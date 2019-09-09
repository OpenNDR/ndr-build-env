APP ?= $(NAME)

SRCDIR := $(NBE_ROOT)/$S
LDFLAGS += --as-needed -ldl

.PHONY: build
build: $(LIBLIST) $(OBJLIST) $(PICLIST) lkapp cpapp

.PHONY: depset
depset: mkdir $(HDRS)

mkdir::
	#Output directories pre-init
	@[ -d $(NBE_MK_OBJPATH) ] || mkdir -p $(NBE_MK_OBJPATH)
	@[ -d $(NBE_INCPATH) ] || mkdir -p $(NBE_INCPATH)
	@[ -d $(NBE_LIBPATH) ] || mkdir -p $(NBE_LIBPATH)
	@[ -d $(NBE_APPPATH) ] || mkdir -p $(NBE_APPPATH)

$(LIBLIST)::
	$(eval LIBFLAG += $(addprefix -l,$@))

$(OBJLIST)::
	$(eval LNKLIST += $(wildcard $(NBE_MK_OBJPATH)/$@/*.o))

$(PICLIST)::
	$(eval LNKLIST += $(wildcard $(NBE_MK_PICPATH)/$@/*.o))

lkapp::
	@gcc -o $(APP).app $(LNKLIST) -L$(NBE_LIBPATH) $(NBE_LIBS) $(LIBFLAG)

cpapp::
	@cp -f $(APP).app $(NBE_APPPATH)
