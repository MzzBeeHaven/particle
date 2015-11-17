
ifeq (,$(SYSTEM_PART1_MODULE_VERSION))
$(error SYSTEM_PART1_MODULE_VERSION not defined)
endif

ifeq (,$(SYSTEM_PART2_MODULE_VERSION))
$(error SYSTEM_PART2_MODULE_VERSION not defined)
endif

GLOBAL_DEFINES += MODULE_VERSION=$(SYSTEM_PART2_MODULE_VERSION)
GLOBAL_DEFINES += MODULE_FUNCTION=$(MODULE_FUNCTION_SYSTEM_PART)
GLOBAL_DEFINES += MODULE_INDEX=2
GLOBAL_DEFINES += MODULE_DEPENDENCY=${MODULE_FUNCTION_SYSTEM_PART},1,${SYSTEM_PART1_MODULE_VERSION}

LINKER_FILE=$(SYSTEM_PART2_MODULE_PATH)/linker.ld
LINKER_DEPS += $(LINKER_FILE) $(HAL_WICED_LIB_FILES)

LINKER_DEPS += $(SYSTEM_PART2_MODULE_PATH)/module_system_part2_export.ld
LINKER_DEPS += $(SYSTEM_PART1_MODULE_PATH)/module_system_part1_export.ld
LINKER_DEPS += $(USER_PART_MODULE_PATH)/module_user_export.ld

LDFLAGS += --specs=nano.specs -lnosys
LDFLAGS += -Wl,--whole-archive $(HAL_WICED_LIB_FILES) -Wl,--no-whole-archive
LDFLAGS += -L$(SYSTEM_PART1_MODULE_PATH)
LDFLAGS += -L$(USER_PART_MODULE_PATH)
LDFLAGS += -T$(LINKER_FILE)
LDFLAGS += -Wl,--defsym,PLATFORM_DFU=$(PLATFORM_DFU)
LDFLAGS += -Wl,-Map,$(TARGET_BASE).map

ifneq ("$(HAL_MINIMAL)","y")
USE_PRINTF_FLOAT ?= y
endif

ifeq ("$(USE_PRINTF_FLOAT)","y")
LDFLAGS += -u _printf_float
endif
        
LDFLAGS += -u uxTopUsedPriority

SYSTEM_PART2_SRC_PATH = $(SYSTEM_PART2_MODULE_PATH)/src

CPPSRC += $(call target_files,$(SYSTEM_PART2_SRC_PATH),*.cpp)
CSRC += $(call target_files,$(SYSTEM_PART2_SRC_PATH),*.c)

CPPFLAGS += -std=gnu++11
