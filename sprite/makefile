TARGET	 = sprite.gb
CC	 = wla-gb
CFLAGS	 = -ox
LD	 = wlalink
LDFLAGS	 = -s

LINKFILE = linkfile
SFILES 	= main.s
IFILES 	= nintendo_logo.i
OFILES 	= main.o

.PHONY: default all clean
.PRECIOUS: $(TARGET) $(OBJECTS)


default: $(TARGET)


all: $(OFILES) makefile
	$(LD) $(LDFLAGS) $(LINKFILE) $(TARGET)

main.o: main.s nintendo_logo.i
	$(CC) $(CFLAGS) main.s main.o


$(TARGET): $(OFILES)
	$(LD) $(LDFLAGS) $(LINKFILE) $@

$(OFILES): $(HFILES)

clean:
	-rm -f *.o
	-rm -f $(TARGET)
	-rm -f *.sym
