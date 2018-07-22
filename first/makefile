TARGET	= pew
SOURCES = src/
CC		= wla-gb
CFLAGS	= -ox
LD		= wlalink
LDFLAGS	= -vs

.PHONY: default all clean

SFILES = $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))
OBJECTS = $(patsubst %.s, %.o, $(wildcard $(SOURCES)*.s))

all: $(OFILES) makefile
	$(LD) $(LDFLAGS) linkfile pew.gb
