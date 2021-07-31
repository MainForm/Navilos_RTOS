ARCH = armv7-a
MCPU = cortex-a8

TARGET = realview-pb-a8

CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OC = arm-none-eabi-objcopy

GDB = gdb-multiarch
GDB_PORT = 1234

EMULATOR = qemu-system-arm

LINKER_SCRIPT = ./navilos.ld
MAP_FILE = build/navilos.map

ASM_SRCS = $(wildcard boot/*.S)
ASM_OBJS = $(patsubst boot/%.S, build/%.os, $(ASM_SRCS))

VPATH = boot \
		hal/$(TARGET) \
		lib

C_SRCS	= $(notdir $(wildcard boot/*.c))
C_SRCS += $(notdir $(wildcard hal/$(TARGET)/*.c))
C_SRCS += $(notdir $(wildcard lib/*.c))
C_OBJS	= $(patsubst %.c, build/%.o, $(C_SRCS))

INC_DIRS =	-I include		 \
			-I hal			 \
			-I hal/$(TARGET) \
			-I lib

CFLAGS = -c -g -std=c11

navilos = build/navilos.axf
navilos_bin = build/navilos.bin

.PHONY: all clean run debug gdb

all: $(navilos)

clean:
	@rm -fr build

run: $(navilos)
	$(EMULATOR) -M $(TARGET) -kernel $(navilos) -nographic

debug: $(navilos)
	$(EMULATOR) -M $(TARGET) -kernel $(navilos) -S -gdb tcp::$(GDB_PORT),ipv4

gdb:
	$(GDB)

$(navilos): $(ASM_OBJS) $(C_OBJS) $(LINKER_SCRPT)
	$(LD) -n -T $(LINKER_SCRIPT) -o $(navilos) $(ASM_OBJS) $(C_OBJS) -Map=$(MAP_FILE)
	$(OC) -O binary $(navilos) $(navilos_bin)

build/%.os: %.S
	mkdir -p $(shell dirname $@)
	$(CC) -march=$(ARCH) -mcpu=$(MCPU) $(INC_DIRS) $(CFLAGS) -o $@ $<

build/%.o: %.c
	mkdir -p $(shell dirname $@)
	$(CC) -march=$(ARCH) -mcpu=$(MCPU) $(INC_DIRS) $(CFLAGS) -o $@ $<
