TARGET	 = bg.gb
AS	 = wla-gb
ASFLAGS	 = -x
LD	 = wlalink
LDFLAGS	 = -v

LINKFILE = linkfile
SFILES	= $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))
OFILES 	= $(patsubst %.s, %.o, $(wildcard *.s))

.PHONY: default all clean
.PRECIOUS: $(TARGET) $(OBJECTS)


default: $(TARGET)
all: default

$(TARGET): $(OFILES)
	$(LD) $(LDFLAGS) $(LINKFILE) $@

%.o: %.s
	$(AS) $(ASFLAGS) -o $@ $<


clean:
	-rm -f $(TARGET)
	-rm -f *.o
	-rm -f *.sym
