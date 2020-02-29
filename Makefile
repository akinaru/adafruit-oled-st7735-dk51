PROJECT_NAME := adafruit_st7735_dk51

export OUTPUT_FILENAME
#MAKEFILE_NAME := $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
MAKEFILE_NAME := $(MAKEFILE_LIST)
MAKEFILE_DIR := $(dir $(MAKEFILE_NAME) ) 

TEMPLATE_PATH = $(NRF51_SDK_DIR)/components/toolchain/gcc
ifeq ($(OS),Windows_NT)
include $(TEMPLATE_PATH)/Makefile.windows
else
include $(TEMPLATE_PATH)/Makefile.posix
endif

MK := mkdir
RM := rm -rf

#echo suspend
ifeq ("$(VERBOSE)","1")
NO_ECHO := 
else
NO_ECHO := @
endif

# Toolchain commands
CC              := '$(GNU_INSTALL_ROOT)/bin/$(GNU_PREFIX)-gcc'
AS              := '$(GNU_INSTALL_ROOT)/bin/$(GNU_PREFIX)-as'
AR              := '$(GNU_INSTALL_ROOT)/bin/$(GNU_PREFIX)-ar' -r
LD              := '$(GNU_INSTALL_ROOT)/bin/$(GNU_PREFIX)-ld'
NM              := '$(GNU_INSTALL_ROOT)/bin/$(GNU_PREFIX)-nm'
OBJDUMP         := '$(GNU_INSTALL_ROOT)/bin/$(GNU_PREFIX)-objdump'
OBJCOPY         := '$(GNU_INSTALL_ROOT)/bin/$(GNU_PREFIX)-objcopy'
SIZE            := '$(GNU_INSTALL_ROOT)/bin/$(GNU_PREFIX)-size'

#function for removing duplicates in a list
remduplicates = $(strip $(if $1,$(firstword $1) $(call remduplicates,$(filter-out $(firstword $1),$1))))

# $(abspath $(NRF51_SDK_DIR)/components/drivers_nrf/delay/nrf_delay.c) not there anymore ?

#source common to all targets
C_SOURCE_FILES += \
$(abspath $(NRF51_SDK_DIR)/components/libraries/button/app_button.c) \
$(abspath $(NRF51_SDK_DIR)/components/libraries/util/app_error_weak.c) \
$(abspath $(NRF51_SDK_DIR)/components/libraries/util/app_error.c) \
$(abspath $(NRF51_SDK_DIR)/components/libraries/timer/app_timer.c) \
$(abspath $(NRF51_SDK_DIR)/components/libraries/util/app_util_platform.c) \
$(abspath $(NRF51_SDK_DIR)/components/libraries/util/nrf_assert.c) \
$(abspath $(NRF51_SDK_DIR)/components/drivers_nrf/common/nrf_drv_common.c) \
$(abspath $(NRF51_SDK_DIR)/components/drivers_nrf/gpiote/nrf_drv_gpiote.c) \
$(abspath $(NRF51_SDK_DIR)/components/libraries/gpiote/app_gpiote.c) \
$(abspath $(NRF51_SDK_DIR)/components/drivers_nrf/spi_master/nrf_drv_spi.c) \
$(abspath $(NRF51_SDK_DIR)/components/drivers_ext/segger_rtt/SEGGER_RTT_printf.c) \
$(abspath $(NRF51_SDK_DIR)/components/drivers_ext/segger_rtt/SEGGER_RTT.c) \
$(abspath $(NRF51_SDK_DIR)/components/drivers_nrf/hal/nrf_adc.c) \
$(abspath $(NRF51_SDK_DIR)/components/boards/boards.c) \
$(abspath $(NRF51_SDK_DIR)/components/libraries/bsp/bsp.c) \
$(abspath src/common.c) \
$(abspath src/adafruit1_8_oled_library.c) \
$(abspath src/main.c) \
$(abspath $(NRF51_SDK_DIR)/components/toolchain/system_nrf51.c)

#assembly files common to all targets
ASM_SOURCE_FILES  = $(abspath $(NRF51_SDK_DIR)/components/toolchain/gcc/gcc_startup_nrf51.S)

#INC_PATHS += -I$(abspath $(NRF51_SDK_DIR)/components/drivers_nrf/pstorage) not there anymore ?
#INC_PATHS += -I$(abspath $(NRF51_SDK_DIR)/components/drivers_nrf/config) not there anymore ?

#includes common to all targets
INC_PATHS += -I$(abspath include)
INC_PATHS += -I$(abspath $(NRF51_SDK_DIR)/components/libraries/bsp)
INC_PATHS += -I$(abspath $(NRF51_SDK_DIR)/components/drivers_nrf/nrf_soc_nosd)
INC_PATHS += -I$(abspath $(NRF51_SDK_DIR)/components/device)
INC_PATHS += -I$(abspath $(NRF51_SDK_DIR)/components/drivers_nrf/hal)
INC_PATHS += -I$(abspath $(NRF51_SDK_DIR)/components/libraries/button)
INC_PATHS += -I$(abspath $(NRF51_SDK_DIR)/components/drivers_nrf/delay)
INC_PATHS += -I$(abspath $(NRF51_SDK_DIR)/components/libraries/util)
INC_PATHS += -I$(abspath $(NRF51_SDK_DIR)/components/drivers_nrf/common)
INC_PATHS += -I$(abspath $(NRF51_SDK_DIR)/components/toolchain)
INC_PATHS += -I$(abspath $(NRF51_SDK_DIR)/components/libraries/timer)
INC_PATHS += -I$(abspath $(NRF51_SDK_DIR)/components/drivers_nrf/spi_master)
INC_PATHS += -I$(abspath $(NRF51_SDK_DIR)/components/drivers_nrf/gpiote)
INC_PATHS += -I$(abspath $(NRF51_SDK_DIR)/components/toolchain/gcc)
INC_PATHS += -I$(abspath $(NRF51_SDK_DIR)/components/drivers_ext/segger_rtt)
INC_PATHS += -I$(abspath $(NRF51_SDK_DIR)/components/toolchain/cmsis/include)
INC_PATHS += -I$(abspath $(NRF51_SDK_DIR)/components/libraries/log)
INC_PATHS += -I$(abspath $(NRF51_SDK_DIR)/components/libraries/log/src)
INC_PATHS += -I$(abspath $(NRF51_SDK_DIR)/components/boards)
INC_PATHS += -I$(abspath $(NRF51_SDK_DIR)/examples/dfu/experimental_ant_bootloader)
INC_PATHS += -I$(abspath $(NRF51_SDK_DIR)/components/libraries/gpiote)

OBJECT_DIRECTORY = _build
LISTING_DIRECTORY = $(OBJECT_DIRECTORY)
OUTPUT_BINARY_DIRECTORY = $(OBJECT_DIRECTORY)

# Sorting removes duplicates
BUILD_DIRECTORIES := $(sort $(OBJECT_DIRECTORY) $(OUTPUT_BINARY_DIRECTORY) $(LISTING_DIRECTORY) )

#flags common to all targets
CFLAGS  = -DNRF51
CFLAGS += -DSWI_DISABLE0
CFLAGS += -DBOARD_PCA10028
CFLAGS += -mcpu=cortex-m0
CFLAGS += -mthumb -mabi=aapcs --std=gnu99
CFLAGS += -Wall -O3 -Werror
CFLAGS += -mfloat-abi=soft
# keep every function in separate section. This will allow linker to dump unused functions
CFLAGS += -ffunction-sections -fdata-sections -fno-strict-aliasing
CFLAGS += -fno-builtin --short-enums
CFLAGS += -DNRF51422

# keep every function in separate section. This will allow linker to dump unused functions
LDFLAGS += -Xlinker -Map=$(LISTING_DIRECTORY)/$(OUTPUT_FILENAME).map
LDFLAGS += -mthumb -mabi=aapcs -L $(TEMPLATE_PATH) -T$(LINKER_SCRIPT)
LDFLAGS += -mcpu=cortex-m0
# let linker to dump unused sections
LDFLAGS += -Wl,--gc-sections
# use newlib in nano version
LDFLAGS += --specs=nano.specs -lc -lnosys

# Assembler flags
ASMFLAGS += -x assembler-with-cpp
ASMFLAGS += -DNRF51
ASMFLAGS += -DSWI_DISABLE0
ASMFLAGS += -DBOARD_PCA10028
ASMFLAGS += -DNRF51422

#default target - first one defined
default: clean nrf51422_xxac

#building all targets
all: clean
	$(NO_ECHO)$(MAKE) -f $(MAKEFILE_NAME) -C $(MAKEFILE_DIR) -e cleanobj
	$(NO_ECHO)$(MAKE) -f $(MAKEFILE_NAME) -C $(MAKEFILE_DIR) -e nrf51422_xxac

#target for printing all targets
help:
	@echo following targets are available:
	@echo 	nrf51422_xxac


C_SOURCE_FILE_NAMES = $(notdir $(C_SOURCE_FILES))
C_PATHS = $(call remduplicates, $(dir $(C_SOURCE_FILES) ) )
C_OBJECTS = $(addprefix $(OBJECT_DIRECTORY)/, $(C_SOURCE_FILE_NAMES:.c=.o) )

ASM_SOURCE_FILE_NAMES = $(notdir $(ASM_SOURCE_FILES))
ASM_PATHS = $(call remduplicates, $(dir $(ASM_SOURCE_FILES) ))
ASM_OBJECTS = $(addprefix $(OBJECT_DIRECTORY)/, $(ASM_SOURCE_FILE_NAMES:.S=.o) )

vpath %.c $(C_PATHS)
vpath %.S $(ASM_PATHS)

OBJECTS = $(C_OBJECTS) $(ASM_OBJECTS)

nrf51422_xxac: OUTPUT_FILENAME := nrf51422_xxac
nrf51422_xxac: LINKER_SCRIPT=adafruit_st7735_gcc_nrf51.ld
nrf51422_xxac: $(BUILD_DIRECTORIES) $(OBJECTS)
	@echo Linking target: $(OUTPUT_FILENAME).out
	$(NO_ECHO)$(CC) $(LDFLAGS) $(OBJECTS) $(LIBS) -o $(OUTPUT_BINARY_DIRECTORY)/$(OUTPUT_FILENAME).out
	$(NO_ECHO)$(MAKE) -f $(MAKEFILE_NAME) -C $(MAKEFILE_DIR) -e finalize

## Create build directories
$(BUILD_DIRECTORIES):
	echo $(MAKEFILE_NAME)
	$(MK) $@

# Create objects from C SRC files
$(OBJECT_DIRECTORY)/%.o: %.c
	@echo Compiling file: $(notdir $<)
	$(NO_ECHO)$(CC) $(CFLAGS) $(INC_PATHS) -c -o $@ $<

# Assemble files
$(OBJECT_DIRECTORY)/%.o: %.S
	@echo Compiling file: $(notdir $<)
	$(NO_ECHO)$(CC) $(ASMFLAGS) $(INC_PATHS) -c -o $@ $<

# Link
$(OUTPUT_BINARY_DIRECTORY)/$(OUTPUT_FILENAME).out: $(BUILD_DIRECTORIES) $(OBJECTS)
	@echo Linking target: $(OUTPUT_FILENAME).out
	$(NO_ECHO)$(CC) $(LDFLAGS) $(OBJECTS) $(LIBS) -o $(OUTPUT_BINARY_DIRECTORY)/$(OUTPUT_FILENAME).out


## Create binary .bin file from the .out file
$(OUTPUT_BINARY_DIRECTORY)/$(OUTPUT_FILENAME).bin: $(OUTPUT_BINARY_DIRECTORY)/$(OUTPUT_FILENAME).out
	@echo Preparing: $(OUTPUT_FILENAME).bin
	$(NO_ECHO)$(OBJCOPY) -O binary $(OUTPUT_BINARY_DIRECTORY)/$(OUTPUT_FILENAME).out $(OUTPUT_BINARY_DIRECTORY)/$(OUTPUT_FILENAME).bin

## Create binary .hex file from the .out file
$(OUTPUT_BINARY_DIRECTORY)/$(OUTPUT_FILENAME).hex: $(OUTPUT_BINARY_DIRECTORY)/$(OUTPUT_FILENAME).out
	@echo Preparing: $(OUTPUT_FILENAME).hex
	$(NO_ECHO)$(OBJCOPY) -O ihex $(OUTPUT_BINARY_DIRECTORY)/$(OUTPUT_FILENAME).out $(OUTPUT_BINARY_DIRECTORY)/$(OUTPUT_FILENAME).hex

finalize: genbin genhex echosize

genbin:
	@echo Preparing: $(OUTPUT_FILENAME).bin
	$(NO_ECHO)$(OBJCOPY) -O binary $(OUTPUT_BINARY_DIRECTORY)/$(OUTPUT_FILENAME).out $(OUTPUT_BINARY_DIRECTORY)/$(OUTPUT_FILENAME).bin

## Create binary .hex file from the .out file
genhex: 
	@echo Preparing: $(OUTPUT_FILENAME).hex
	$(NO_ECHO)$(OBJCOPY) -O ihex $(OUTPUT_BINARY_DIRECTORY)/$(OUTPUT_FILENAME).out $(OUTPUT_BINARY_DIRECTORY)/$(OUTPUT_FILENAME).hex

echosize:
	-@echo ''
	$(NO_ECHO)$(SIZE) $(OUTPUT_BINARY_DIRECTORY)/$(OUTPUT_FILENAME).out
	-@echo ''

clean:
	$(RM) $(BUILD_DIRECTORIES)

cleanobj:
	$(RM) $(BUILD_DIRECTORIES)/*.o

flash: $(MAKECMDGOALS)
	@echo Flashing: $(OUTPUT_BINARY_DIRECTORY)/$<.hex
	nrfjprog --program $(OUTPUT_BINARY_DIRECTORY)/$<.hex -f nrf51  --chiperase
	nrfjprog --reset

## Flash softdevice