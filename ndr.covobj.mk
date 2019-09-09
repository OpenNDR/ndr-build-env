COVOBJ ?= $(NAME)

SUBCOMP += test
include $(NBE_DIR)/ndr.subcomp.mk

SRCDIR := $(NBE_ROOT)/$S

.PHONY: build
build: $(ASMS) $(SRCS) savepath

.PHONY: depset
depset: mkdir $(HDRS)

mkdir::
	#Output directories pre-init
	@[ -d $(NBE_MK_INCPATH) ] || mkdir -p $(NBE_MK_INCPATH)
	@[ -d $(NBE_MK_OBJPATH) ] || mkdir -p $(NBE_MK_OBJPATH)
	@[ -d $(NBE_MK_OBJPATH)/$(COVOBJ) ] || mkdir -p $(NBE_MK_OBJPATH)/$(COVOBJ)
	@[ -d $(NBE_MK_COVPATH) ] || mkdir -p $(NBE_MK_COVPATH)
	@[ -d $(NBE_MK_COVPATH)/$(COVOBJ) ] || mkdir -p $(NBE_MK_COVPATH)/$(COVOBJ)
	@[ -d $(NBE_INCPATH) ] || mkdir -p $(NBE_INCPATH)
	@[ -d $(NBE_COVPATH) ] || mkdir -p $(NBE_COVPATH)

$(HDRS)::
	@echo $@:$(SRCDIR):$(NBE_MK_INCPATH) >> $(NBE_PATHLOG_RESTORE)
	@cp -f $(SRCDIR)/$@ $(NBE_MK_INCPATH)

$(ASMS)::
	@gcc -c -o $(basename $@).raw.o $(SRCDIR)/$@ -I$(NBE_INCPATH) -I$(NBE_MK_INCPATH) $(CFLAGS) $(EXTRA_CFLAGS)
	@cp -f $(basename $@).raw.o $(NBE_MK_OBJPATH)/$(COVOBJ)/$(basename $@).o
	@cp -f $(basename $@).raw.o $(NBE_MK_COVPATH)/$(COVOBJ)/$(basename $@).o

$(SRCS)::
	@gcc -c -o $(basename $@).raw.o $(SRCDIR)/$@ -I$(NBE_INCPATH) -I$(NBE_MK_INCPATH) $(CFLAGS) $(EXTRA_CFLAGS)
	@cp -f $(basename $@).raw.o $(NBE_MK_OBJPATH)/$(COVOBJ)/$(basename $@).o
	@echo $@:$(SRCDIR):$(NBE_MK_COVPATH)/$(COVOBJ) >> $(NBE_PATHLOG_RESTORE)
	@gcc -c $(SRCDIR)/$@ -I$(NBE_INCPATH) -I$(NBE_MK_INCPATH) $(CFLAGS) $(EXTRA_CFLAGS) -fprofile-arcs -ftest-coverage
	@cp -f $(basename $@).o $(NBE_MK_COVPATH)/$(COVOBJ)
	@cp -f $(basename $@).gcno $(NBE_MK_COVPATH)/$(COVOBJ)
	@cp -f $(SRCDIR)/$@ $(NBE_MK_COVPATH)/$(COVOBJ)

savepath::
	@echo -n $(SRCDIR) >> $(NBE_MK_COVPATH)/$(COVOBJ)/source.path
	@echo -n $(shell pwd) >> $(NBE_MK_COVPATH)/$(COVOBJ)/build.path
