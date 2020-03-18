# Copyright 2014 Ives Rey-Otero <ivesreyotero@gmail.com>

# compilers configuration
CC = gcc
OFLAGS = -g -O3
LIBS = -L/usr/local/lib -lpng -lm

CFLAGS = -Wall -Wno-write-strings  -pedantic -std=c99 -D_POSIX_C_SOURCE=200809L

# Source files with executables.
SRC_ALGO = sift_cli

SRC_MATCH = match_cli

# TEMP normalized_patch
SRC_DEMO = demo_extract_patch

SRCa = lib_sift.cpp \
	   lib_sift_anatomy.cpp \
	   lib_scalespace.cpp \
	   lib_description.cpp \
       lib_discrete.cpp \
	   lib_keypoint.cpp \
	   lib_util.cpp

SRCb = lib_io_scalespace.cpp

SRCc = lib_matching.cpp

SRCDIR = src
OBJDIR = src
BINDIR = bin

OBJa = $(addprefix $(OBJDIR)/,$(SRCa:.cpp=.o))
OBJb = $(addprefix $(OBJDIR)/,$(SRCb:.cpp=.o))
OBJc = $(addprefix $(OBJDIR)/,$(SRCc:.cpp=.o))

OBJ = $(OBJa) $(OBJb) $(OBJc)

BIN = $(addprefix $(BINDIR)/,$(SRC_ALGO))
BINMATCH = $(addprefix $(BINDIR)/,$(SRC_MATCH))
BINDEMO = $(addprefix $(BINDIR)/,$(SRC_DEMO))

sift= $(BIN)
match= $(BINMATCH)
demo= $(BINDEMO)
default: $(OBJDIR) $(BINDIR) $(sift) $(match) $(demo)

#---------------------------------------------------------------
#  SIFT CLI
#

$(BIN) : $(BINDIR)/% : $(SRCDIR)/%.cpp $(OBJDIR)/lib_sift_anatomy.o  $(OBJDIR)/lib_keypoint.o $(OBJDIR)/lib_scalespace.o $(OBJDIR)/lib_description.o   $(OBJDIR)/lib_discrete.o  $(OBJDIR)/lib_io_scalespace.o  $(OBJDIR)/lib_util.o   $(OBJDIR)/io_png.o $(OBJDIR)/lib_sift.o
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)

$(OBJDIR):
	    -mkdir -p $(OBJDIR)

$(BINDIR):
	    -mkdir -p $(BINDIR)

#---------------------------------------------------------------
#  LIB_SIFT
#
$(OBJDIR)/lib_sift.o : $(SRCDIR)/lib_sift.cpp $(OBJDIR)/lib_sift_anatomy.o $(OBJDIR)/lib_keypoint.o $(OBJDIR)/lib_util.o 
	$(CC) $(CFLAGS) $(OFLAGS) -c -o $@ $<

$(OBJDIR)/lib_scalespace.o : $(SRCDIR)/lib_scalespace.cpp $(OBJDIR)/lib_discrete.o  $(OBJDIR)/lib_util.o 
	$(CC) $(CFLAGS) $(OFLAGS) -c -o $@ $<

$(OBJDIR)/lib_discrete.o : $(SRCDIR)/lib_discrete.cpp $(OBJDIR)/lib_util.o 
	$(CC) $(CFLAGS) $(OFLAGS) -c -o $@ $<

$(OBJDIR)/lib_description.o : $(SRCDIR)/lib_description.cpp $(OBJDIR)/lib_discrete.o $(OBJDIR)/lib_keypoint.o $(OBJDIR)/lib_util.o 
	$(CC) $(CFLAGS) $(OFLAGS) -c -o $@ $<

$(OBJDIR)/lib_keypoint.o : $(SRCDIR)/lib_keypoint.cpp $(OBJDIR)/lib_util.o 
	$(CC) $(CFLAGS) $(OFLAGS) -c -o $@ $<

$(OBJDIR)/lib_sift_anatomy.o : $(SRCDIR)/lib_sift_anatomy.cpp $(OBJDIR)/lib_keypoint.o $(OBJDIR)/lib_discrete.o $(OBJDIR)/lib_scalespace.o $(OBJDIR)/lib_util.o 
	$(CC) $(CFLAGS) $(OFLAGS) -c -o $@ $<

$(OBJDIR)/lib_util.o : $(SRCDIR)/lib_util.cpp
	$(CC) $(CFLAGS) $(OFLAGS) -c -o $@ $<

#--------------------------------------------------------------
#   IN (image) and OUT (scalespace)
#
$(OBJDIR)/io_png.o : $(SRCDIR)/io_png.cpp
	$(CC) $(CFLAGS) $(OFLAGS) -c -o $@ $<

$(OBJDIR)/lib_io_scalespace.o : $(SRCDIR)/lib_io_scalespace.cpp $(OBJDIR)/io_png.o  $(OBJDIR)/lib_scalespace.o $(OBJDIR)/lib_util.o 
	$(CC) $(CFLAGS) $(OFLAGS) -c -o $@ $<


#-------------------------------------------------------------
#   Matching algorithm
#
$(OBJDIR)/lib_matching.o : $(SRCDIR)/lib_matching.cpp $(OBJDIR)/lib_keypoint.o $(OBJDIR)/lib_util.o 
	$(CC) $(CFLAGS) $(OFLAGS) -c -o $@ $<

$(BINMATCH) : $(SRCDIR)/match_cli.cpp $(OBJDIR)/lib_keypoint.o $(OBJDIR)/lib_matching.o   $(OBJDIR)/lib_util.o 
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS) -lm

#-------------------------------------------------------------
#  Tools used in the demo 
#
$(BINDEMO) : $(BINDIR)/% :	 $(SRCDIR)/demo_extract_patch.cpp  $(OBJDIR)/lib_discrete.o $(OBJDIR)/io_png.o $(OBJDIR)/lib_util.o 
	$(CC) $(CFLAGS) -o $@ $^ $(LIBS)


#-------------------------------------------------------------------------------------
#  clean
#
cleanobj:
	-rm -f $(OBJ)

clean: cleanobj
	-rm -f $(BIN)
