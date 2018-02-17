NBE_UNAME := $(shell uname -m)

ifneq (, $(filter $(NBE_UNAME), x86 i386 i686))
	NBE_ARCHTYPE ?= X86_32
else ifneq (, $(filter $(NBE_UNAME), x86_64 amd64))
	NBE_ARCHTYPE ?= X86_64
else ifneq (, $(filter $(NBE_UNAME), armv6% armv7%))
	NBE_ARCHTYPE ?= ARM_32
else ifneq (, $(filter $(NBE_UNAME), armv8%))
	NBE_ARCHTYPE ?= ARM_64
else
	NBE_ARCHTYPE ?= UNKNOWN
endif

ifeq ($(NBE_ARCHTYPE), X86_32)
	CFLAGS += -DNBE_ARCH_X86_32
else ifeq ($(NBE_ARCHTYPE), X86_64)
	CFLAGS += -DNBE_ARCH_X86_64
else ifeq ($(NBE_ARCHTYPE), ARM_32)
	CFLAGS += -DNBE_ARCH_ARM32
else ifeq ($(NBE_ARCHTYPE), ARM_64)
	CFLAGS += -DNBE_ARCH_ARM64
endif

NBE_ARCHBIT_32 := -m32
NBE_ARCHBIT_64 := -m64
NBE_ARCHBIT := $(shell getconf LONG_BIT)
ifneq (, $(filter $(NBE_ARCHBIT), 32 64))
	CFLAGS += $(NBE_ARCHBIT_$(NBE_ARCHBIT))
endif

export NBE_ARCHTYPE