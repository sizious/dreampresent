TARGET = dreampresent.elf

OBJS = src/dreampresent.o src/main.o romdisk.o src/dckos.o

# order here is important!
MRB_SOURCES = src/dc_kos_rb.rb src/page_data.rb src/presentation.rb src/dreampresent.rb src/start.rb

MRB_BYTECODE = src/dreampresent.c

KOS_ROMDISK_DIR = romdisk

MRB_ROOT = /opt/mruby

CFLAGS = -I$(MRB_ROOT)/include/ -L$(MRB_ROOT)/build/dreamcast/lib/

all: rm-elf $(TARGET)

include $(KOS_BASE)/Makefile.rules

clean:
	-rm -f $(TARGET) $(OBJS) romdisk.* $(MRB_BYTECODE)

rm-elf:
	-rm -f $(TARGET) romdisk.*

$(TARGET): $(OBJS) $(MRB_BYTECODE)
	kos-cc $(CFLAGS) -o $(TARGET) $(OBJS) -lmruby -lm -lpng -lkosutils -lz

$(MRB_BYTECODE): src/dreampresent.rb
	$(MRB_ROOT)/bin/mrbc -g -Bdreampresent_bytecode -o src/dreampresent.c $(MRB_SOURCES)

run: $(TARGET)
	$(KOS_LOADER) $(TARGET)

dist:
	rm -f $(OBJS) romdisk.o romdisk.img
	$(KOS_STRIP) $(TARGET)
