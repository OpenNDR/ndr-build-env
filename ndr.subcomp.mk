ifneq ($(origin SUBCOMP), undefined)
	SUBCOMP_DIR += $(foreach SUBCOMP_ITER, $(SUBCOMP), $(NBE_DIR)/ndr.$(SUBCOMP_ITER).subcomp)
	CFLAGS += $(foreach SUBCOMP_ITER, $(SUBCOMP), $(addprefix -D, NBE_SUBCOMP_$(shell echo $(SUBCOMP_ITER) | tr a-z A-Z)))
	CFLAGS += $(foreach SUBCOMP_ITER, $(SUBCOMP_DIR), $(addprefix -I, $(SUBCOMP_ITER)))
endif