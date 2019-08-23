_LDLIBS-y += -Wl,--as-needed
_LDLIBS-y += $(EXECENV_LDLIBS)

LDLIBS += $(_LDLIBS-y) $(CPU_LDLIBS) $(EXTRA_LDLIBS)

include $(NBE_DIR)/ndr.build.helper/nbh.libsort.mk

NBE_LIBS := $(call filter-libs,$(LDLIBS))
export NBE_LIBS
