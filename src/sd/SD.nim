##
##
##   SD - a slightly more friendly wrapper for sdfatlib
##
##   This library aims to expose a subset of SD card functionality
##   in the form of a higher level "wrapper" object.
##
##   License: GNU General Public License V3
##           (Because sdfatlib is licensed with this.)
##
##   (C) Copyright 2010 SparkFun Electronics
##
##
import
  utility/SdFat#, utility/SdFatUtil

{. compile: "SD.cpp".}
{. compile: "File.cpp".}
{. compile: "utility/SdFile.cpp".}
{. compile: "../spi/SPI.cpp" .}


const
  FILE_READ* {.intdefine.} = O_READ
  FILE_WRITE* {.intdefine.} = (O_READ xor O_WRITE xor O_CREAT xor O_APPEND)

type
  File* {.importcpp: "SDLib::File", header: "SD.h", byref.} = object
    ##  our name
    ##  underlying file pointer

proc constructFile*(f: SdFile; name: cstring): File {.constructor,
    importcpp: "SDLib::File(@)", header: "SD.h".}
proc constructFile*(): File {.constructor, importcpp: "SDLib::File(@)", header: "SD.h".}
proc write*(this: var File; a2: uint8): csize_t {.importcpp: "write", header: "SD.h".}
proc write*(this: var File; buf: ptr uint8; size: csize_t): csize_t {.importcpp: "write",
    header: "SD.h".}
proc availableForWrite*(this: var File): cint {.importcpp: "availableForWrite",
    header: "SD.h".}
proc read*(this: var File): cint {.importcpp: "read", header: "SD.h".}
proc peek*(this: var File): cint {.importcpp: "peek", header: "SD.h".}
proc available*(this: var File): cint {.importcpp: "available", header: "SD.h".}
proc flush*(this: var File) {.importcpp: "flush", header: "SD.h".}
proc read*(this: var File; buf: pointer; nbyte: uint16): cint {.importcpp: "read",
    header: "SD.h".}
proc seek*(this: var File; pos: uint32): bool {.importcpp: "seek", header: "SD.h".}
proc position*(this: var File): uint32 {.importcpp: "position", header: "SD.h".}
proc size*(this: var File): uint32 {.importcpp: "size", header: "SD.h".}
proc close*(this: var File) {.importcpp: "close", header: "SD.h".}
converter `bool`*(this: var File): bool {.importcpp: "File::operator bool",
                                     header: "SD.h".}
proc name*(this: var File): cstring {.importcpp: "name", header: "SD.h".}
proc isDirectory*(this: var File): bool {.importcpp: "isDirectory", header: "SD.h".}
proc openNextFile*(this: var File; mode: uint8 = O_RDONLY): File {.
    importcpp: "openNextFile", header: "SD.h".}
proc rewindDirectory*(this: var File) {.importcpp: "rewindDirectory", header: "SD.h".}
type
  SDClass* {.importcpp: "SDLib::SDClass", header: "SD.h", byref.} = object ##  These are required for initialisation and use of sdfatlib
                                                                    ##  This needs to be called to set up the connection to the SD card
                                                                    ##  before other methods are used.
                                                                    ##  This is used to determine the mode used to open a file
                                                                    ##  it's here because it's the easiest place to pass the
                                                                    ##  information through the directory walking function. But
                                                                    ##  it's probably not the best place for it.
                                                                    ##  It shouldn't be set directly--it is set via the parameters to `open`.
    ##  my quick&dirty iterator, should be replaced


proc begin*(this: var SDClass; csPin: uint8 = 4): bool {.
    importcpp: "begin", header: "SD.h".}
proc begin*(this: var SDClass; clock: uint32; csPin: uint8): bool {.
    importcpp: "begin", header: "SD.h".}
proc `end`*(this: var SDClass) {.importcpp: "end", header: "SD.h".}
proc open*(this: var SDClass; filename: cstring; mode: uint8 = FILE_READ): File {.
    importcpp: "open", header: "SD.h".}
# proc open*(this: var SDClass; filename: String; mode: uint8 = FILE_READ): File {.
#     importcpp: "open", header: "SD.h".}
proc exists*(this: var SDClass; filepath: cstring): bool {.importcpp: "exists",
    header: "SD.h".}
# proc exists*(this: var SDClass; filepath: String): bool {.importcpp: "exists",
#     header: "SD.h".}
proc mkdir*(this: var SDClass; filepath: cstring): bool {.importcpp: "mkdir",
    header: "SD.h".}
# proc mkdir*(this: var SDClass; filepath: String): bool {.importcpp: "mkdir",
#     header: "SD.h".}
proc remove*(this: var SDClass; filepath: cstring): bool {.importcpp: "remove",
    header: "SD.h".}
# proc remove*(this: var SDClass; filepath: String): bool {.importcpp: "remove",
#     header: "SD.h".}
proc rmdir*(this: var SDClass; filepath: cstring): bool {.importcpp: "rmdir",
    header: "SD.h".}
# proc rmdir*(this: var SDClass; filepath: String): bool {.importcpp: "rmdir",
#     header: "SD.h".}
var SDc* {.importcpp: "SD", header: "SD.h".}: SDClass

##  We enclose File and SD classes in namespace SDLib to avoid conflicts
##  with others legacy libraries that redefines File class.
##  This ensure compatibility with sketches that uses only SD library

# nil
##  This allows sketches to use SDLib::File with other libraries (in the
##  sketch you must use SDFile instead of File to disambiguate)

type
  SDFile* = File
  SDFileSystemClass* = SDClass

# var
#   SDFileSystem* = SD
