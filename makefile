# Makefile for all scythe-based projects

# Platform-specific defines
STATIC_LIB_EXT = .a
AR = ar rcs
ifeq ($(OS),Windows_NT)
	#CCFLAGS += -D WIN32
	MAKE := mingw32-make.exe
	LDFLAGS = -s -shared
	CC = gcc
	CCP = g++
	PLATFORM_SUFFIX = mingw32
	SHARED_LIB_EXT = .so
else
	MAKE := make
	LDFLAGS = -shared -fPIC
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		#CCFLAGS += -D LINUX
		CC = gcc
		CCP = g++
		PLATFORM_SUFFIX = unix
		SHARED_LIB_EXT = .so
	endif
	ifeq ($(UNAME_S),Darwin)
		#CCFLAGS += -D OSX
		CC = clang
		CCP = clang++
		PLATFORM_SUFFIX = macosx
		SHARED_LIB_EXT = .dylib
		# OSX has its own CURL with command line tools
		CURL_LIB := curl
	endif
endif

# Exports
export STATIC_LIB_EXT
export SHARED_LIB_EXT
export CC
export CCP
export AR
export LDFLAGS

LIBRARY_DIRS = thirdparty scythe
BINARY_DIRS = demos
DIRS_ORDER = $(LIBRARY_DIRS) install_libs $(BINARY_DIRS)

LIB_PATH = lib

all: $(DIRS_ORDER)

$(LIBRARY_DIRS):
	@echo Get down to $@
	@$(MAKE) -C $@

$(BINARY_DIRS):
	@echo Get down to $@
	@$(MAKE) -C $@

create_libs_dir:
	@test -d $(LIB_PATH) || mkdir $(LIB_PATH)

install_libs: create_libs_dir
	@find $(LIB_PATH) -name "*$(STATIC_LIB_EXT)" -type f -delete
	@find thirdparty -name "*$(STATIC_LIB_EXT)" -type f -exec cp {} $(LIB_PATH) \;
	@find scythe -name "*$(STATIC_LIB_EXT)" -type f -exec cp {} $(LIB_PATH) \;

.PHONY: $(DIRS_ORDER)