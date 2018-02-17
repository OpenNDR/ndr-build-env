_LDLIBS-y += -Wl,--as-needed
_LDLIBS-y += $(EXECENV_LDLIBS)

LDLIBS += $(_LDLIBS-y) $(CPU_LDLIBS) $(EXTRA_LDLIBS)

allbutfirst = $(wordlist 2,$(words $(1)),$(1))

filter-libs = \
	$(if $(1),$(strip\
		$(if \
			$(and \
				$(filter $(firstword $(1)),$(call allbutfirst,$(1))),\
				$(filter -l%,$(firstword $(1)))),\
			,\
			$(firstword $(1))) \
		$(call filter-libs,$(call allbutfirst,$(1)))))

NBE_LIBS := $(call filter-libs,$(LDLIBS))
export NBE_LIBS