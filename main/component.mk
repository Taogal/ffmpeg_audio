#
# "main" pseudo-component makefile.
#
# (Uses default behaviour of compiling all source files in directory, adding 'include' to include path.)



SDL_DIR_INC =$(PRJ_PATH)/components/include/sdl2.0
SDL_DIR_LIB =$(PRJ_PATH)/components

FFMPEG_DIR_INC =$(PRJ_PATH)/components/include/ffmpeg
FFMPEG_DIR_LIB =$(PRJ_PATH)/components

CFLAGS += -I $(SDL_DIR_INC)/include -I $(FFMPEG_DIR_INC)/include

COMPONENT_ADD_LDFLAGS += -L$(SDL_DIR_LIB)/lib -L$(FFMPEG_DIR_LIB)/lib
COMPONENT_ADD_LDFLAGS += -lSDL2 -lavcodec -lavformat -lswresample -lavdevice -lavutil  -lswscale -lavfilter -lpostproc