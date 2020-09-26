##  Arduino SdFat Library
##    Copyright (C) 2009 by William Greiman
##
##    This file is part of the Arduino SdFat Library
##
##    This Library is free software: you can redistribute it and/or modify
##    it under the terms of the GNU General Public License as published by
##    the Free Software Foundation, either version 3 of the License, or
##    (at your option) any later version.
##
##    This Library is distributed in the hope that it will be useful,
##    but WITHOUT ANY WARRANTY; without even the implied warranty of
##    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##    GNU General Public License for more details.
##
##    You should have received a copy of the GNU General Public License
##    along with the Arduino SdFat Library.  If not, see
##    <http://www.gnu.org/licenses/>.
##

## *
##    \file
##    SdFile and SdVolume classes
##

# when defined(__AVR__) or defined(__CPU_ARC__):
import
  Sd2Card, FatStructs

## ------------------------------------------------------------------------------
## *
##    Allow use of deprecated functions if non-zero
##

type
  SdVolume* {.importcpp: "SdVolume", header: "SdFat.h", bycopy.} = object ## * Create an instance of SdVolume
                                                                  ##  Allow SdFile access to SdVolume private data.
    ##  value for action argument in cacheRawBlock to indicate cache dirty
    ##  512 byte cache for device blocks
    ##  Logical number of block in the cache
    ##  Sd2Card object for cache
    ##  cacheFlush() will write block if true
    ##  block number for mirror FAT
    ##
    ##  start cluster for alloc search
    ##  cluster size in blocks
    ##  FAT size in blocks
    ##  clusters in one FAT
    ##  shift to convert cluster count to block count
    ##  first data block number
    ##  number of FATs on volume
    ##  start block for first FAT
    ##  volume type (12, 16, OR 32)
    ##  number of entries in FAT16 root dir
    ##  root start block for FAT16, cluster for FAT32
    ## ----------------------------------------------------------------------------


# const
#   ALLOW_DEPRECATED_FUNCTIONS* {.intdefine.} : = 1

## ------------------------------------------------------------------------------
##  forward declaration since SdVolume is used in SdFile

# "forward decl of SdVolume"
# when defined(O_RDONLY):        ## ARDUINO_ARCH_MBED
##  flags for ls()
## * ls() flag to print modify date

const LS_DATE* {.intdefine.} = 1

## * ls() flag to print file size

const LS_SIZE* {.intdefine.} = 2

## * ls() flag for recursive list of subdirectories

const LS_R* {.intdefine.} = 4

##  use the gnu style oflag in open()
## * open() oflag for reading

const O_READ* {.intdefine.} = 0x01'u8

## * open() oflag - same as O_READ

const O_RDONLY* {.intdefine.} = O_READ

## * open() oflag for write

const O_WRITE* {.intdefine.} = 0x002'u8

## * open() oflag - same as O_WRITE

const O_WRONLY* {.intdefine.} = O_WRITE

## * open() oflag for reading and writing

const O_RDWR* {.intdefine.} = O_READ xor O_WRITE

## * open() oflag mask for access modes

const O_ACCMODE* {.intdefine.} = O_READ xor O_WRITE

## * The file offset shall be set to the end of the file prior to each write.

const O_APPEND* {.intdefine.} = 0x04'u8

## * synchronous writes - call sync() after each write

const O_SYNC* = 0x08'u8

## * create the file if nonexistent

const O_CREAT* {.intdefine.} = 0x10'u8

## * If O_CREAT and O_EXCL are set, open() shall fail if the file exists

var O_EXCL* {.importcpp: "O_EXCL", header: "SdFat.h".}: uint8

## * truncate the file to zero length

var O_TRUNC* {.importcpp: "O_TRUNC", header: "SdFat.h".}: uint8

##  flags for timestamp
## * set the file's last access date

var T_ACCESS* {.importcpp: "T_ACCESS", header: "SdFat.h".}: uint8

## * set the file's creation date and time

var T_CREATE* {.importcpp: "T_CREATE", header: "SdFat.h".}: uint8

## * Set the file's write date and time

var T_WRITE* {.importcpp: "T_WRITE", header: "SdFat.h".}: uint8

##  values for type_
## * This SdFile has not been opened.

var FAT_FILE_TYPE_CLOSED* {.importcpp: "FAT_FILE_TYPE_CLOSED", header: "SdFat.h".}: uint8

## * SdFile for a file

var FAT_FILE_TYPE_NORMAL* {.importcpp: "FAT_FILE_TYPE_NORMAL", header: "SdFat.h".}: uint8

## * SdFile for a FAT16 root directory

var FAT_FILE_TYPE_ROOT16* {.importcpp: "FAT_FILE_TYPE_ROOT16", header: "SdFat.h".}: uint8

## * SdFile for a FAT32 root directory

var FAT_FILE_TYPE_ROOT32* {.importcpp: "FAT_FILE_TYPE_ROOT32", header: "SdFat.h".}: uint8

## * SdFile for a subdirectory

var FAT_FILE_TYPE_SUBDIR* {.importcpp: "FAT_FILE_TYPE_SUBDIR", header: "SdFat.h".}: uint8

## * Test value for directory type

var FAT_FILE_TYPE_MIN_DIR* {.importcpp: "FAT_FILE_TYPE_MIN_DIR", header: "SdFat.h".}: uint8

## * date field for FAT directory entry

proc FAT_DATE*(year: uint16; month: uint8; day: uint8): uint16 =
  discard

## * year part of FAT directory date field

proc FAT_YEAR*(fatDate: uint16): uint16 =
  discard

## * month part of FAT directory date field

proc FAT_MONTH*(fatDate: uint16): uint8 =
  discard

## * day part of FAT directory date field

proc FAT_DAY*(fatDate: uint16): uint8 =
  discard

## * time field for FAT directory entry

proc FAT_TIME*(hour: uint8; minute: uint8; second: uint8): uint16 =
  discard

## * hour part of FAT directory time field

proc FAT_HOUR*(fatTime: uint16): uint8 =
  discard

## * minute part of FAT directory time field

proc FAT_MINUTE*(fatTime: uint16): uint8 =
  discard

## * second part of FAT directory time field

proc FAT_SECOND*(fatTime: uint16): uint8 =
  discard

## * Default date for file timestamps is 1 Jan 2000

var FAT_DEFAULT_DATE* {.importcpp: "FAT_DEFAULT_DATE", header: "SdFat.h".}: uint16

## * Default time for file timestamp is 1 am

var FAT_DEFAULT_TIME* {.importcpp: "FAT_DEFAULT_TIME", header: "SdFat.h".}: uint16

## ------------------------------------------------------------------------------
## *
##    \class SdFile
##    \brief Access FAT16 and FAT32 files on SD and SDHC cards.
##

type
  SdFile* {.importcpp: "SdFile", header: "SdFat.h", bycopy.} = object ## * Create an instance of SdFile.
                                                                     ##  bits defined in flags_
                                                                     ##  should be 0XF
    ##  available bits
    ##  a new cluster was added to the file
    ##  use unbuffered SD read
    ##  sync of directory entry required
    ##  make sure F_OFLAG is ok
    ##      #if ((F_FILE_NON_BLOCKING_WRITE | F_FILE_CLUSTER_ADDED | F_FILE_UNBUFFERED_READ | F_FILE_DIR_DIRTY) & F_OFLAG)
    ##  #error flags_ bits conflict
    ##      #endif  // flags_ bits
    ##  private data
    ##  See above for definition of flags_ bits
    ##  type of file see above for values
    ##  cluster for current file position
    ##  current file position in bytes from beginning
    ##  SD block that contains directory entry for file
    ##  index of entry in dirBlock 0 <= dirIndex_ <= 0XF
    ##  file size in bytes
    ##  first cluster of file
    ##  volume where file is located
    ##  private functions


proc constructSdFile*(): SdFile {.constructor, importcpp: "SdFile(@)",
                               header: "SdFat.h".}
proc clearUnbufferedRead*(this: var SdFile) {.importcpp: "clearUnbufferedRead",
    header: "SdFat.h".}
proc close*(this: var SdFile): uint8 {.importcpp: "close", header: "SdFat.h".}
proc contiguousRange*(this: var SdFile; bgnBlock: ptr uint32; endBlock: ptr uint32): uint8 {.
    importcpp: "contiguousRange", header: "SdFat.h".}
proc createContiguous*(this: var SdFile; dirFile: ptr SdFile; fileName: cstring;
                      size: uint32): uint8 {.importcpp: "createContiguous",
    header: "SdFat.h".}
proc curCluster*(this: SdFile): uint32 {.noSideEffect, importcpp: "curCluster",
                                       header: "SdFat.h".}
proc curPosition*(this: SdFile): uint32 {.noSideEffect, importcpp: "curPosition",
                                        header: "SdFat.h".}
proc dateTimeCallback*(dateTime: proc (date: ptr uint16; time: ptr uint16)) {.
    importcpp: "SdFile::dateTimeCallback(@)", header: "SdFat.h".}
proc dateTimeCallbackCancel*() {.importcpp: "SdFile::dateTimeCallbackCancel(@)",
                               header: "SdFat.h".}
proc dirBlock*(this: SdFile): uint32 {.noSideEffect, importcpp: "dirBlock",
                                     header: "SdFat.h".}
proc dirEntry*(this: var SdFile; dir: ptr dir_t): uint8 {.importcpp: "dirEntry",
    header: "SdFat.h".}
proc dirIndex*(this: SdFile): uint8 {.noSideEffect, importcpp: "dirIndex",
                                    header: "SdFat.h".}
proc dirName*(dir: dir_t; name: cstring) {.importcpp: "SdFile::dirName(@)",
                                      header: "SdFat.h".}
proc fileSize*(this: SdFile): uint32 {.noSideEffect, importcpp: "fileSize",
                                     header: "SdFat.h".}
proc firstCluster*(this: SdFile): uint32 {.noSideEffect, importcpp: "firstCluster",
    header: "SdFat.h".}
proc isDir*(this: SdFile): uint8 {.noSideEffect, importcpp: "isDir",
                                 header: "SdFat.h".}
proc isFile*(this: SdFile): uint8 {.noSideEffect, importcpp: "isFile",
                                  header: "SdFat.h".}
proc isOpen*(this: SdFile): uint8 {.noSideEffect, importcpp: "isOpen",
                                  header: "SdFat.h".}
proc isSubDir*(this: SdFile): uint8 {.noSideEffect, importcpp: "isSubDir",
                                    header: "SdFat.h".}
proc isRoot*(this: SdFile): uint8 {.noSideEffect, importcpp: "isRoot",
                                  header: "SdFat.h".}
proc ls*(this: var SdFile; flags: uint8 = 0; indent: uint8 = 0) {.importcpp: "ls",
    header: "SdFat.h".}
proc makeDir*(this: var SdFile; dir: ptr SdFile; dirName: cstring): uint8 {.
    importcpp: "makeDir", header: "SdFat.h".}
proc open*(this: var SdFile; dirFile: ptr SdFile; index: uint16; oflag: uint8): uint8 {.
    importcpp: "open", header: "SdFat.h".}
proc open*(this: var SdFile; dirFile: ptr SdFile; fileName: cstring; oflag: uint8): uint8 {.
    importcpp: "open", header: "SdFat.h".}
proc openRoot*(this: var SdFile; vol: ptr SdVolume): uint8 {.importcpp: "openRoot",
    header: "SdFat.h".}
proc printDirName*(dir: dir_t; width: uint8) {.
    importcpp: "SdFile::printDirName(@)", header: "SdFat.h".}
proc printFatDate*(fatDate: uint16) {.importcpp: "SdFile::printFatDate(@)",
                                     header: "SdFat.h".}
proc printFatTime*(fatTime: uint16) {.importcpp: "SdFile::printFatTime(@)",
                                     header: "SdFat.h".}
proc printTwoDigits*(v: uint8) {.importcpp: "SdFile::printTwoDigits(@)",
                                header: "SdFat.h".}
proc read*(this: var SdFile): int16 {.importcpp: "read", header: "SdFat.h".}
proc read*(this: var SdFile; buf: pointer; nbyte: uint16): int16 {.importcpp: "read",
    header: "SdFat.h".}
proc readDir*(this: var SdFile; dir: ptr dir_t): int8 {.importcpp: "readDir",
    header: "SdFat.h".}
proc remove*(dirFile: ptr SdFile; fileName: cstring): uint8 {.
    importcpp: "SdFile::remove(@)", header: "SdFat.h".}
proc remove*(this: var SdFile): uint8 {.importcpp: "remove", header: "SdFat.h".}
proc rewind*(this: var SdFile) {.importcpp: "rewind", header: "SdFat.h".}
proc rmDir*(this: var SdFile): uint8 {.importcpp: "rmDir", header: "SdFat.h".}
proc rmRfStar*(this: var SdFile): uint8 {.importcpp: "rmRfStar", header: "SdFat.h".}
proc seekCur*(this: var SdFile; pos: uint32): uint8 {.importcpp: "seekCur",
    header: "SdFat.h".}
proc seekEnd*(this: var SdFile): uint8 {.importcpp: "seekEnd", header: "SdFat.h".}
proc seekSet*(this: var SdFile; pos: uint32): uint8 {.importcpp: "seekSet",
    header: "SdFat.h".}
proc setUnbufferedRead*(this: var SdFile) {.importcpp: "setUnbufferedRead",
                                        header: "SdFat.h".}
proc timestamp*(this: var SdFile; flag: uint8; year: uint16; month: uint8;
               day: uint8; hour: uint8; minute: uint8; second: uint8): uint8 {.
    importcpp: "timestamp", header: "SdFat.h".}
proc sync*(this: var SdFile; blocking: uint8 = 1): uint8 {.importcpp: "sync",
    header: "SdFat.h".}
proc `type`*(this: SdFile): uint8 {.noSideEffect, importcpp: "type",
                                  header: "SdFat.h".}
proc truncate*(this: var SdFile; size: uint32): uint8 {.importcpp: "truncate",
    header: "SdFat.h".}
proc unbufferedRead*(this: SdFile): uint8 {.noSideEffect,
    importcpp: "unbufferedRead", header: "SdFat.h".}
proc volume*(this: SdFile): ptr SdVolume {.noSideEffect, importcpp: "volume",
                                      header: "SdFat.h".}
proc write*(this: var SdFile; b: uint8): csize_t {.importcpp: "write", header: "SdFat.h".}
proc write*(this: var SdFile; buf: pointer; nbyte: uint16): csize_t {.importcpp: "write",
    header: "SdFat.h".}
proc write*(this: var SdFile; str: cstring): csize_t {.importcpp: "write",
    header: "SdFat.h".}
proc availableForWrite*(this: var SdFile): cint {.importcpp: "availableForWrite",
    header: "SdFat.h".}
## ==============================================================================
##  SdVolume class
## *
##    \brief Cache for an SD data block
##

type
  cache_t* {.importcpp: "cache_t", header: "SdFat.h", bycopy.} = object {.union.}
    data* {.importc: "data".}: array[512, uint8] ## * Used to access cached file data blocks.
    ## * Used to access cached FAT16 entries.
    fat16* {.importc: "fat16".}: array[256, uint16] ## * Used to access cached FAT32 entries.
    fat32* {.importc: "fat32".}: array[128, uint32] ## * Used to access cached directory entries.
    dir* {.importc: "dir".}: array[16, dir_t] ## * Used to access a cached MasterBoot Record.
    mbr* {.importc: "mbr".}: mbr_t ## * Used to access to a cached FAT boot sector.
    fbs* {.importc: "fbs".}: fbs_t


## ------------------------------------------------------------------------------
## *
##    \class SdVolume
##    \brief Access FAT16 and FAT32 volumes on SD and SDHC cards.
##



proc constructSdVolume*(): SdVolume {.constructor, importcpp: "SdVolume(@)",
                                   header: "SdFat.h".}
proc cacheClear*(): ptr uint8 {.importcpp: "SdVolume::cacheClear(@)",
                              header: "SdFat.h".}
proc init*(this: var SdVolume; dev: ptr Sd2Card): uint8 {.importcpp: "init",
    header: "SdFat.h".}
proc init*(this: var SdVolume; dev: ptr Sd2Card; part: uint8): uint8 {.
    importcpp: "init", header: "SdFat.h".}
proc blocksPerCluster*(this: SdVolume): uint8 {.noSideEffect,
    importcpp: "blocksPerCluster", header: "SdFat.h".}
proc blocksPerFat*(this: SdVolume): uint32 {.noSideEffect,
    importcpp: "blocksPerFat", header: "SdFat.h".}
proc clusterCount*(this: SdVolume): uint32 {.noSideEffect,
    importcpp: "clusterCount", header: "SdFat.h".}
proc clusterSizeShift*(this: SdVolume): uint8 {.noSideEffect,
    importcpp: "clusterSizeShift", header: "SdFat.h".}
proc dataStartBlock*(this: SdVolume): uint32 {.noSideEffect,
    importcpp: "dataStartBlock", header: "SdFat.h".}
proc fatCount*(this: SdVolume): uint8 {.noSideEffect, importcpp: "fatCount",
                                      header: "SdFat.h".}
proc fatStartBlock*(this: SdVolume): uint32 {.noSideEffect,
    importcpp: "fatStartBlock", header: "SdFat.h".}
proc fatType*(this: SdVolume): uint8 {.noSideEffect, importcpp: "fatType",
                                     header: "SdFat.h".}
proc rootDirEntryCount*(this: SdVolume): uint32 {.noSideEffect,
    importcpp: "rootDirEntryCount", header: "SdFat.h".}
proc rootDirStart*(this: SdVolume): uint32 {.noSideEffect,
    importcpp: "rootDirStart", header: "SdFat.h".}
proc sdCard*(): ptr Sd2Card {.importcpp: "SdVolume::sdCard(@)", header: "SdFat.h".}
