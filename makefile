# Makefile for all scythe-based projects

# Platform-specific defines
STATIC_LIB_EXT = .a
AR = ar rcs
ifeq ($(OS),Windows_NT)
	#CCFLAGS += -D WIN32
	MAKE := mingw32-make.exe
	SL = \\
	LDFLAGS = -s -shared
	LIBRARY_PATH := $(shell cd)\\lib
	CC := gcc
	CXX := g++
	SHARED_LIB_EXT = .so
else
	MAKE := make
	SL = /
	LDFLAGS = -shared -fPIC
	LIBRARY_PATH := $(shell pwd)/lib
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		#CCFLAGS += -D LINUX
		CC := gcc
		CXX := g++
		SHARED_LIB_EXT = .so
	endif
	ifeq ($(UNAME_S),Darwin)
		#CCFLAGS += -D OSX
		CC := clang
		CXX := clang++
		SHARED_LIB_EXT = .dylib
		# OSX has its own CURL with command line tools
		CURL_LIB := curl
	endif
endif

# Exports
export STATIC_LIB_EXT
export SHARED_LIB_EXT
export CC
export CXX
export AR
export LDFLAGS
export LIBRARY_PATH

LIBRARY_DIRS = thirdparty scythe
BINARY_DIRS = demos
DIRS_ORDER = \
	create_libs_dir $(LIBRARY_DIRS) \
	$(BINARY_DIRS)

ifeq ($(OS),Windows_NT)
	CREATE_LIBS_DIR = if not exist $(LIBRARY_PATH) mkdir $(LIBRARY_PATH)
else
	CREATE_LIBS_DIR = test -d $(LIBRARY_PATH) || mkdir -p $(LIBRARY_PATH)
endif

all: $(DIRS_ORDER)

.PHONY: clean
clean:
	@$(foreach directory, $(LIBRARY_DIRS) $(BINARY_DIRS), $(MAKE) -C $(directory) clean ;)

.PHONY: help
help:
	@echo available targets: all clean

$(LIBRARY_DIRS):
	@$(MAKE) -C $@ $@

$(BINARY_DIRS):
	@$(MAKE) -C $@ $@

create_libs_dir:
	@$(CREATE_LIBS_DIR)

.PHONY: $(DIRS_ORDER)
