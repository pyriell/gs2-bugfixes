TICPP_DIR 	= ./tinyxml
INCS		= 
CC		= g++ $(INCS)
LD		= ld
EXE		= sppgui.exe
COPTS		= -O2 -Wall -s
LDFLAGS		= -mwindows -static-libgcc -static-libstdc++ -lcomctl32 -lShlwapi
BUILDDATE	= $(shell date +%Y-%0m-%0d)
# BIG_INT library

OBJS	= patcher.o runbatch.o patchlist.o pugixml.o resource.o

all:	$(OBJS)
	$(CC) $(COPTS) -o $(EXE) $(OBJS) $(LDFLAGS)
	cp $(EXE) ../../$(EXE)

release:
	7z a -tzip ../../GS2_Patch_$(BUILDDATE).zip @../../releaselist.txt
	
clean:
	rm -f *.o *.exe *~

rebuild:	clean all

resource.o:	spp_resource.rc
		windres -o resource.o spp_resource.rc