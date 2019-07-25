ifneq ($(origin NBE_DPDK_VERSION), undefined)

RTE_SDK ?= $(NBE_ROOT)/dpdk
export RTE_SDK
RTE_TARGET ?= x86_64-native-linuxapp-gcc
export RTE_TARGET

NBE_DPDKPATH ?= $(RTE_SDK)/$(RTE_TARGET)
export NBE_DPDKPATH

include $(RTE_SDK)/mk/rte.vars.mk

ifneq ($(CONFIG_RTE_EXEC_ENV),"linuxapp")
$(error This application can only operate in a linuxapp environment, \
please change the definition of the RTE_TARGET environment variable)
endif

include $(NBE_DIR)/ndr.dpdk.preset/dpdk.$(NBE_DPDK_VERSION).mk
EXTRA_LDLIBS += $(DPDKLIBS)
export EXTRA_LDLIBS

endif
