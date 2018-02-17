ifneq ($(origin NBE_WARNLEVEL), undefined)
	ifeq ($(NBE_WARNLEVEL), PARANOID)
		CFLAGS += -Wall, -Wextra, -Wuninitialized, -pendantic
	else ifeq ($(NBE_WARNLEVEL), STRICT)
		CFLAGS += -Wall, -Wextra
	else ifeq ($(NBE_WARNLEVEL), DEFAULT)
		CFLAGS += -Wall
	endif
endif