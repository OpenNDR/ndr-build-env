SRCDIR := $(NBE_ROOT)/$S

mkdir::
	@[ -d $(NBE_MK_COVPATH) ] || mkdir -p $(NBE_MK_COVPATH)
	@[ -d $(NBE_COVPATH) ] || mkdir -p $(NBE_COVPATH)

$(HDRS)::
	@cp -f $(SRCDIR)/$@ $(NBE_MK_COVPATH)

$(SRCS)::
	@cp -f $(SRCDIR)/$@ $(NBE_MK_COVPATH)