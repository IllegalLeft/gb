TARGET	 = sprite.gb
AS	 = wla-gb
ASFLAGS	 = -ox
LD	 = wlalink
LDFLAGS	 = -vs

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
	$(AS) $(ASFLAGS) $< $@


clean:
	-rm -f $(TARGET)
	-rm -f *.o
	-rm -f *.sym
