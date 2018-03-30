$(SRCS)::
	@gcc -o $(basename $@).pp $(SRCDIR)/$@ -I$(NBE_INCPATH) -I$(NBE_MK_INCPATH) $(CFLAGS) $(EXTRA_CFLAGS) -E
	@cp -f $(basename $@).pp  $(NBE_DBGPATH)
	@gcc -o $(basename $@).asm $(SRCDIR)/$@ -I$(NBE_INCPATH) -I$(NBE_MK_INCPATH) $(CFLAGS) $(EXTRA_CFLAGS) -S
	@cp -f $(basename $@).asm  $(NBE_DBGPATH)