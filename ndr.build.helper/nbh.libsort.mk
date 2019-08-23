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
