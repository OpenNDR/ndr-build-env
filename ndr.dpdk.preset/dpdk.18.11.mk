include $(NBE_DPDKPATH)/.config

_DPDKLIBS-y := -Wl,--as-needed

#
# Order is important: from higher level to lower level
#
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_FLOW_CLASSIFY)  += -lrte_flow_classify
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PIPELINE)       += -Wl,--whole-archive
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PIPELINE)       += -lrte_pipeline
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PIPELINE)       += -Wl,--no-whole-archive
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_TABLE)          += -Wl,--whole-archive
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_TABLE)          += -lrte_table
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_TABLE)          += -Wl,--no-whole-archive
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PORT)           += -Wl,--whole-archive
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PORT)           += -lrte_port
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PORT)           += -Wl,--no-whole-archive

_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PDUMP)          += -lrte_pdump
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_DISTRIBUTOR)    += -lrte_distributor
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_IP_FRAG)        += -lrte_ip_frag
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_METER)          += -lrte_meter
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_LPM)            += -lrte_lpm
# librte_acl needs -Wl,--whole-archive because of weak functions
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_ACL)            += -Wl,--whole-archive
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_ACL)            += -lrte_acl
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_ACL)            += -Wl,--no-whole-archive
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_TELEMETRY)      += --no-as-needed
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_TELEMETRY)      += -Wl,--whole-archive
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_TELEMETRY)      += -lrte_telemetry -ljansson
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_TELEMETRY)      += -Wl,--no-whole-archive
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_TELEMETRY)      += --as-needed
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_JOBSTATS)       += -lrte_jobstats
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_METRICS)        += -lrte_metrics
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_BITRATE)        += -lrte_bitratestats
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_LATENCY_STATS)  += -lrte_latencystats
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_POWER)          += -lrte_power

_DPDKLIBS-$(CONFIG_RTE_LIBRTE_EFD)            += -lrte_efd
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_BPF)            += -lrte_bpf
ifeq ($(CONFIG_RTE_LIBRTE_BPF_ELF),y)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_BPF)            += -lelf
endif

_DPDKLIBS-y += -Wl,--whole-archive

_DPDKLIBS-$(CONFIG_RTE_LIBRTE_CFGFILE)        += -lrte_cfgfile
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_GRO)            += -lrte_gro
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_GSO)            += -lrte_gso
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_HASH)           += -lrte_hash
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_MEMBER)         += -lrte_member
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_VHOST)          += -lrte_vhost
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_KVARGS)         += -lrte_kvargs
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_MBUF)           += -lrte_mbuf
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_NET)            += -lrte_net
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_ETHER)          += -lrte_ethdev
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_BBDEV)          += -lrte_bbdev
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_CRYPTODEV)      += -lrte_cryptodev
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_SECURITY)       += -lrte_security
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_COMPRESSDEV)    += -lrte_compressdev
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_EVENTDEV)       += -lrte_eventdev
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_RAWDEV)         += -lrte_rawdev
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_TIMER)          += -lrte_timer
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_MEMPOOL)        += -lrte_mempool
_DPDKLIBS-$(CONFIG_RTE_DRIVER_MEMPOOL_RING)   += -lrte_mempool_ring
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_RING)           += -lrte_ring
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PCI)            += -lrte_pci
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_EAL)            += -lrte_eal
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_CMDLINE)        += -lrte_cmdline
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_REORDER)        += -lrte_reorder
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_SCHED)          += -lrte_sched

ifeq ($(CONFIG_RTE_EXEC_ENV_LINUXAPP),y)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_KNI)            += -lrte_kni
endif

ifeq ($(CONFIG_RTE_LIBRTE_PMD_OCTEONTX_CRYPTO),y)
_DPDKLIBS-y += -lrte_common_cpt
endif

ifeq ($(CONFIG_RTE_LIBRTE_PMD_OCTEONTX_SSOVF)$(CONFIG_RTE_LIBRTE_OCTEONTX_MEMPOOL),yy)
_DPDKLIBS-y += -lrte_common_octeontx
endif

MVEP-y := $(CONFIG_RTE_LIBRTE_MVPP2_PMD)
MVEP-y += $(CONFIG_RTE_LIBRTE_MVNETA_PMD)
MVEP-y += $(CONFIG_RTE_LIBRTE_PMD_MVSAM_CRYPTO)
ifneq (,$(findstring y,$(MVEP-y)))
_DPDKLIBS-y += -lrte_common_mvep -L$(LIBMUSDK_PATH)/lib -lmusdk
endif

ifeq ($(CONFIG_RTE_LIBRTE_DPAA_BUS),y)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_COMMON_DPAAX)   += -lrte_common_dpaax
endif
ifeq ($(CONFIG_RTE_LIBRTE_FSLMC_BUS),y)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_COMMON_DPAAX)   += -lrte_common_dpaax
endif

_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PCI_BUS)        += -lrte_bus_pci
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_VDEV_BUS)       += -lrte_bus_vdev
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_DPAA_BUS)       += -lrte_bus_dpaa
ifeq ($(CONFIG_RTE_EAL_VFIO),y)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_FSLMC_BUS)      += -lrte_bus_fslmc
endif

ifeq ($(CONFIG_RTE_BUILD_SHARED_LIB),n)
# plugins (link only if static libraries)

_DPDKLIBS-$(CONFIG_RTE_DRIVER_MEMPOOL_BUCKET) += -lrte_mempool_bucket
_DPDKLIBS-$(CONFIG_RTE_DRIVER_MEMPOOL_STACK)  += -lrte_mempool_stack
ifeq ($(CONFIG_RTE_LIBRTE_DPAA_BUS),y)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_DPAA_MEMPOOL)   += -lrte_mempool_dpaa
endif
ifeq ($(CONFIG_RTE_EAL_VFIO)$(CONFIG_RTE_LIBRTE_FSLMC_BUS),yy)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_DPAA2_MEMPOOL)  += -lrte_mempool_dpaa2
endif

_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_AF_PACKET)  += -lrte_pmd_af_packet
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_ARK_PMD)        += -lrte_pmd_ark
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_ATLANTIC_PMD)   += -lrte_pmd_atlantic
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_AVF_PMD)        += -lrte_pmd_avf
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_AVP_PMD)        += -lrte_pmd_avp
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_AXGBE_PMD)      += -lrte_pmd_axgbe
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_BNX2X_PMD)      += -lrte_pmd_bnx2x -lz
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_BNXT_PMD)       += -lrte_pmd_bnxt
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_BOND)       += -lrte_pmd_bond
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_CXGBE_PMD)      += -lrte_pmd_cxgbe
ifeq ($(CONFIG_RTE_LIBRTE_DPAA_BUS),y)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_DPAA_PMD)       += -lrte_pmd_dpaa
endif
ifeq ($(CONFIG_RTE_EAL_VFIO)$(CONFIG_RTE_LIBRTE_FSLMC_BUS),yy)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_DPAA2_PMD)      += -lrte_pmd_dpaa2
endif
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_E1000_PMD)      += -lrte_pmd_e1000
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_ENA_PMD)        += -lrte_pmd_ena
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_ENETC_PMD)      += -lrte_pmd_enetc
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_ENIC_PMD)       += -lrte_pmd_enic
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_FM10K_PMD)      += -lrte_pmd_fm10k
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_FAILSAFE)   += -lrte_pmd_failsafe
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_I40E_PMD)       += -lrte_pmd_i40e
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_IXGBE_PMD)      += -lrte_pmd_ixgbe
ifeq ($(CONFIG_RTE_LIBRTE_KNI),y)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_KNI)        += -lrte_pmd_kni
endif
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_LIO_PMD)        += -lrte_pmd_lio
ifeq ($(CONFIG_RTE_LIBRTE_MLX4_DLOPEN_DEPS),y)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_MLX4_PMD)       += -lrte_pmd_mlx4 -ldl
else
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_MLX4_PMD)       += -lrte_pmd_mlx4 -libverbs -lmlx4
endif
ifeq ($(CONFIG_RTE_LIBRTE_MLX5_DLOPEN_DEPS),y)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_MLX5_PMD)       += -lrte_pmd_mlx5 -ldl -lmnl
else
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_MLX5_PMD)       += -lrte_pmd_mlx5 -libverbs -lmlx5 -lmnl
endif
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_MVPP2_PMD)      += -lrte_pmd_mvpp2
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_MVNETA_PMD)     += -lrte_pmd_mvneta
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_NFP_PMD)        += -lrte_pmd_nfp
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_NULL)       += -lrte_pmd_null
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_PCAP)       += -lrte_pmd_pcap -lpcap
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_QEDE_PMD)       += -lrte_pmd_qede
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_RING)       += -lrte_pmd_ring
ifeq ($(CONFIG_RTE_LIBRTE_SCHED),y)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_SOFTNIC)      += -lrte_pmd_softnic
endif
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_SFC_EFX_PMD)    += -lrte_pmd_sfc_efx
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_SZEDATA2)   += -lrte_pmd_szedata2 -lsze2
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_TAP)        += -lrte_pmd_tap
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_THUNDERX_NICVF_PMD) += -lrte_pmd_thunderx_nicvf
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_VDEV_NETVSC_PMD) += -lrte_pmd_vdev_netvsc
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_VIRTIO_PMD)     += -lrte_pmd_virtio
ifeq ($(CONFIG_RTE_LIBRTE_VHOST),y)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_VHOST)      += -lrte_pmd_vhost
ifeq ($(CONFIG_RTE_EAL_VFIO),y)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_IFC_PMD) += -lrte_pmd_ifc
endif # $(CONFIG_RTE_EAL_VFIO)
endif # $(CONFIG_RTE_LIBRTE_VHOST)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_VMXNET3_PMD)    += -lrte_pmd_vmxnet3_uio

_DPDKLIBS-$(CONFIG_RTE_LIBRTE_VMBUS)          += -lrte_bus_vmbus
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_NETVSC_PMD)     += -lrte_pmd_netvsc

ifeq ($(CONFIG_RTE_LIBRTE_BBDEV),y)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_BBDEV_NULL)     += -lrte_pmd_bbdev_null

# TURBO SOFTWARE PMD is dependent on the FLEXRAN library
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_BBDEV_TURBO_SW) += -lrte_pmd_bbdev_turbo_sw
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_BBDEV_TURBO_SW) += -L$(FLEXRAN_SDK)/lib_crc -lcrc
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_BBDEV_TURBO_SW) += -L$(FLEXRAN_SDK)/lib_turbo -lturbo
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_BBDEV_TURBO_SW) += -L$(FLEXRAN_SDK)/lib_rate_matching -lrate_matching
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_BBDEV_TURBO_SW) += -L$(FLEXRAN_SDK)/lib_common -lcommon
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_BBDEV_TURBO_SW) += -lirc -limf -lstdc++ -lipps
endif # CONFIG_RTE_LIBRTE_BBDEV

ifeq ($(CONFIG_RTE_LIBRTE_CRYPTODEV),y)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_AESNI_MB)    += -lrte_pmd_aesni_mb
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_AESNI_MB)    += -lIPSec_MB
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_AESNI_GCM)   += -lrte_pmd_aesni_gcm
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_AESNI_GCM)   += -lIPSec_MB
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_CCP)         += -lrte_pmd_ccp -lcrypto
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_OPENSSL)     += -lrte_pmd_openssl -lcrypto
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_NULL_CRYPTO) += -lrte_pmd_null_crypto
ifeq ($(CONFIG_RTE_LIBRTE_PMD_QAT),y)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_QAT_SYM)     += -lrte_pmd_qat -lcrypto
endif # CONFIG_RTE_LIBRTE_PMD_QAT
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_SNOW3G)      += -lrte_pmd_snow3g
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_SNOW3G)      += -L$(LIBSSO_SNOW3G_PATH)/build -lsso_snow3g
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_KASUMI)      += -lrte_pmd_kasumi
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_KASUMI)      += -L$(LIBSSO_KASUMI_PATH)/build -lsso_kasumi
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_ZUC)         += -lrte_pmd_zuc
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_ZUC)         += -L$(LIBSSO_ZUC_PATH)/build -lsso_zuc
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_ARMV8_CRYPTO)    += -lrte_pmd_armv8
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_ARMV8_CRYPTO)    += -L$(ARMV8_CRYPTO_LIB_PATH) -larmv8_crypto
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_MVSAM_CRYPTO) += -L$(LIBMUSDK_PATH)/lib -lrte_pmd_mvsam_crypto -lmusdk
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_OCTEONTX_CRYPTO) += -lrte_pmd_octeontx_crypto
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_CRYPTO_SCHEDULER) += -lrte_pmd_crypto_scheduler
ifeq ($(CONFIG_RTE_LIBRTE_SECURITY),y)
ifeq ($(CONFIG_RTE_EAL_VFIO)$(CONFIG_RTE_LIBRTE_FSLMC_BUS),yy)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_DPAA2_SEC)   += -lrte_pmd_dpaa2_sec
endif # CONFIG_RTE_LIBRTE_FSLMC_BUS
ifeq ($(CONFIG_RTE_LIBRTE_DPAA_BUS),y)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_DPAA_SEC)   += -lrte_pmd_dpaa_sec
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_CAAM_JR)   += -lrte_pmd_caam_jr
endif # CONFIG_RTE_LIBRTE_DPAA_BUS
endif # CONFIG_RTE_LIBRTE_SECURITY
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_VIRTIO_CRYPTO) += -lrte_pmd_virtio_crypto
endif # CONFIG_RTE_LIBRTE_CRYPTODEV

ifeq ($(CONFIG_RTE_LIBRTE_COMPRESSDEV),y)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_ISAL) += -lrte_pmd_isal_comp
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_ISAL) += -lisal
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_OCTEONTX_ZIPVF) += -lrte_pmd_octeontx_zip
# Link QAT driver if it has not been linked yet
ifeq ($(CONFIG_RTE_LIBRTE_PMD_QAT_SYM),n)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_QAT)  += -lrte_pmd_qat
endif # CONFIG_RTE_LIBRTE_PMD_QAT_SYM
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_ZLIB) += -lrte_pmd_zlib
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_ZLIB) += -lz
endif # CONFIG_RTE_LIBRTE_COMPRESSDEV

ifeq ($(CONFIG_RTE_LIBRTE_EVENTDEV),y)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_SKELETON_EVENTDEV) += -lrte_pmd_skeleton_event
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_SW_EVENTDEV) += -lrte_pmd_sw_event
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_DSW_EVENTDEV) += -lrte_pmd_dsw_event
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_OCTEONTX_SSOVF) += -lrte_pmd_octeontx_ssovf
ifeq ($(CONFIG_RTE_LIBRTE_DPAA_BUS),y)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_DPAA_EVENTDEV) += -lrte_pmd_dpaa_event
endif # CONFIG_RTE_LIBRTE_DPAA_BUS
ifeq ($(CONFIG_RTE_EAL_VFIO)$(CONFIG_RTE_LIBRTE_FSLMC_BUS),yy)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_DPAA2_EVENTDEV) += -lrte_pmd_dpaa2_event
endif # CONFIG_RTE_LIBRTE_FSLMC_BUS

_DPDKLIBS-$(CONFIG_RTE_LIBRTE_OCTEONTX_MEMPOOL) += -lrte_mempool_octeontx
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_OCTEONTX_PMD) += -lrte_pmd_octeontx
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_OPDL_EVENTDEV) += -lrte_pmd_opdl_event
endif # CONFIG_RTE_LIBRTE_EVENTDEV

ifeq ($(CONFIG_RTE_LIBRTE_RAWDEV),y)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_SKELETON_RAWDEV) += -lrte_pmd_skeleton_rawdev
ifeq ($(CONFIG_RTE_EAL_VFIO)$(CONFIG_RTE_LIBRTE_FSLMC_BUS),yy)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_DPAA2_CMDIF_RAWDEV) += -lrte_pmd_dpaa2_cmdif
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_DPAA2_QDMA_RAWDEV) += -lrte_pmd_dpaa2_qdma
endif # CONFIG_RTE_LIBRTE_FSLMC_BUS
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_IFPGA_BUS)      += -lrte_bus_ifpga
ifeq ($(CONFIG_RTE_LIBRTE_IFPGA_BUS),y)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_PMD_IFPGA_RAWDEV)   += -lrte_pmd_ifpga_rawdev
endif # CONFIG_RTE_LIBRTE_IFPGA_BUS
endif # CONFIG_RTE_LIBRTE_RAWDEV

endif # !CONFIG_RTE_BUILD_SHARED_LIBS

_DPDKLIBS-y += -Wl,--no-whole-archive

ifeq ($(CONFIG_RTE_BUILD_SHARED_LIB),n)
# The static libraries do not know their dependencies.
# So linking with static library requires explicit dependencies.
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_EAL)            += -lrt
ifeq ($(CONFIG_RTE_EXEC_ENV_LINUXAPP)$(CONFIG_RTE_EAL_NUMA_AWARE_HUGEPAGES),yy)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_EAL)            += -lnuma
endif
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_SCHED)          += -lm
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_SCHED)          += -lrt
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_MEMBER)         += -lm
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_METER)          += -lm
ifeq ($(CONFIG_RTE_LIBRTE_VHOST_NUMA),y)
_DPDKLIBS-$(CONFIG_RTE_LIBRTE_VHOST)          += -lnuma
endif
_DPDKLIBS-$(CONFIG_RTE_PORT_PCAP)             += -lpcap
endif # !CONFIG_RTE_BUILD_SHARED_LIBS

_DPDKLIBS-y += -ldl
_DPDKLIBS-y += -lpthread

export _DPDKLIBS-y
