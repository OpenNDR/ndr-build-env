PIC ?= $(NAME)

SRCDIR := $(NBE_ROOT)/$S

.PHONY: build
build: $(SRCS)

.PHONY: depset
depset: mkdir $(HDRS)

mkdir::
	#Output directories pre-init
	@[ -d $(NBE_MK_INCPATH) ] || mkdir -p $(NBE_MK_INCPATH)
	@[ -d $(NBE_MK_PICPATH) ] || mkdir -p $(NBE_MK_PICPATH)
	@[ -d $(NBE_MK_PICPATH)/$(PIC) ] || mkdir -p $(NBE_MK_PICPATH)/$(PIC)
	@[ -d $(NBE_INCPATH) ] || mkdir -p $(NBE_INCPATH)

$(HDRS)::
	@echo $@:$(SRCDIR):$(NBE_MK_INCPATH) >> $(NBE_LOG_PATHLOG)
	@cp -f $(SRCDIR)/$@ $(NBE_MK_INCPATH)

$(SRCS)::
	@gcc -c $(SRCDIR)/$@ -I$(NBE_INCPATH) -I$(NBE_MK_INCPATH) $(CFLAGS) $(EXTRA_CFLAGS)
	@cp -f $(basename $@).o $(NBE_MK_PICPATH)/$(PIC)
