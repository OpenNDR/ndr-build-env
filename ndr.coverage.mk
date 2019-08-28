SRCDIR := $(NBE_ROOT)/$S

mkdir::
	@[ -d $(NBE_MK_INCPATH) ] || mkdir -p $(NBE_MK_INCPATH)
	@[ -d $(NBE_MK_COVPATH) ] || mkdir -p $(NBE_MK_COVPATH)
	@[ -d $(NBE_COVPATH) ] || mkdir -p $(NBE_COVPATH)

$(SRCS)::
	@echo $@:$(SRCDIR)::$(NBE_MK_COVPATH) >> $(NBE_LOG_PATHLOG)
	@cp -f $(SRCDIR)/$@ $(NBE_MK_COVPATH)