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
##    FAT file structures
##
##
##    mostly from Microsoft document fatgen103.doc
##    http://www.microsoft.com/whdc/system/platform/firmware/fatgen.mspx
##
## ------------------------------------------------------------------------------
## * Value for byte 510 of boot block or MBR

var BOOTSIG0* {.importcpp: "BOOTSIG0", header: "FatStructs.h".}: uint8

## * Value for byte 511 of boot block or MBR

var BOOTSIG1* {.importcpp: "BOOTSIG1", header: "FatStructs.h".}: uint8

## ------------------------------------------------------------------------------
## *
##    \struct partitionTable
##    \brief MBR partition table entry
##
##    A partition table entry for a MBR formatted storage device.
##    The MBR partition table has four entries.
##

type
  partitionTable* {.importcpp: "partitionTable", header: "FatStructs.h", bycopy.} = object ## *
                                                                                   ##      Boot Indicator . Indicates whether the volume is the active
                                                                                   ##      partition.  Legal values include: 0X00. Do not use for booting.
                                                                                   ##      0X80 Active partition.
                                                                                   ##
                                                                                   ##  __attribute__((packed))
    boot* {.importc: "boot".}: uint8 ## *
                                   ##       Head part of Cylinder-head-sector address of the first block in
                                   ##       the partition. Legal values are 0-255. Only used in old PC BIOS.
                                   ##
    beginHead* {.importc: "beginHead".}: uint8 ## *
                                             ##      Sector part of Cylinder-head-sector address of the first block in
                                             ##      the partition. Legal values are 1-63. Only used in old PC BIOS.
                                             ##
    reserved* {.importc: "reserved".}: cuchar ##  unsigned beginSector : 6;
                                          ##  /\** High bits cylinder for first block in partition. *\/
                                          ##  unsigned beginCylinderHigh : 2;
                                          ## *
                                          ##      Combine beginCylinderLow with beginCylinderHigh. Legal values
                                          ##      are 0-1023.  Only used in old PC BIOS.
                                          ##
    beginCylinderLow* {.importc: "beginCylinderLow".}: uint8 ## *
                                                           ##      Partition type. See defines that begin with PART_TYPE_ for
                                                           ##      some Microsoft partition types.
                                                           ##
    `type`* {.importc: "type".}: uint8 ## *
                                     ##      head part of cylinder-head-sector address of the last sector in the
                                     ##      partition.  Legal values are 0-255. Only used in old PC BIOS.
                                     ##
    endHead* {.importc: "endHead".}: uint8 ## *
                                         ##      Sector part of cylinder-head-sector address of the last sector in
                                         ##      the partition.  Legal values are 1-63. Only used in old PC BIOS.
                                         ##
    reserved2* {.importc: "reserved2".}: cuchar ##  unsigned endSector : 6;
                                            ##  /\** High bits of end cylinder *\/
                                            ##  unsigned endCylinderHigh : 2;
                                            ## *
                                            ##      Combine endCylinderLow with endCylinderHigh. Legal values
                                            ##      are 0-1023.  Only used in old PC BIOS.
                                            ##
    endCylinderLow* {.importc: "endCylinderLow".}: uint8 ## * Logical block address of the first block in the partition.
    firstSector* {.importc: "firstSector".}: uint32 ## * Length of the partition, in blocks.
    totalSectors* {.importc: "totalSectors".}: uint32


## * Type name for partitionTable

type
  part_t* = partitionTable

## ------------------------------------------------------------------------------
## *
##    \struct masterBootRecord
##
##    \brief Master Boot Record
##
##    The first block of a storage device that is formatted with a MBR.
##

type
  masterBootRecord* {.importcpp: "masterBootRecord", header: "FatStructs.h", bycopy.} = object ##
                                                                                       ## *
                                                                                       ## Code
                                                                                       ## Area
                                                                                       ## for
                                                                                       ## master
                                                                                       ## boot
                                                                                       ## program.
                                                                                       ##
                                                                                       ## __attribute__((packed))
    codeArea* {.importc: "codeArea".}: array[440, uint8] ## * Optional WindowsNT disk signature. May contain more boot code.
    diskSignature* {.importc: "diskSignature".}: uint32 ## * Usually zero but may be more boot code.
    usuallyZero* {.importc: "usuallyZero".}: uint16 ## * Partition tables.
    part* {.importc: "part".}: array[4, part_t] ## * First MBR signature byte. Must be 0X55
    mbrSig0* {.importc: "mbrSig0".}: uint8 ## * Second MBR signature byte. Must be 0XAA
    mbrSig1* {.importc: "mbrSig1".}: uint8


## * Type name for masterBootRecord

type
  mbr_t* = masterBootRecord

## ------------------------------------------------------------------------------
## *
##    \struct biosParmBlock
##
##    \brief BIOS parameter block
##
##     The BIOS parameter block describes the physical layout of a FAT volume.
##

type
  biosParmBlock* {.importcpp: "biosParmBlock", header: "FatStructs.h", bycopy.} = object ## *
                                                                                 ##      Count of bytes per sector. This value may take on only the
                                                                                 ##      following values: 512, 1024, 2048 or 4096
                                                                                 ##
                                                                                 ##  __attribute__((packed))
    bytesPerSector* {.importc: "bytesPerSector".}: uint16 ## *
                                                        ##      Number of sectors per allocation unit. This value must be a
                                                        ##      power of 2 that is greater than 0. The legal values are
                                                        ##      1, 2, 4, 8, 16, 32, 64, and 128.
                                                        ##
    sectorsPerCluster* {.importc: "sectorsPerCluster".}: uint8 ## *
                                                             ##      Number of sectors before the first FAT.
                                                             ##      This value must not be zero.
                                                             ##
    reservedSectorCount* {.importc: "reservedSectorCount".}: uint16 ## * The count of FAT data structures on the volume. This field should
                                                                  ##       always contain the value 2 for any FAT volume of any type.
                                                                  ##
    fatCount* {.importc: "fatCount".}: uint8 ## *
                                           ##     For FAT12 and FAT16 volumes, this field contains the count of
                                           ##     32-byte directory entries in the root directory. For FAT32 volumes,
                                           ##     this field must be set to 0. For FAT12 and FAT16 volumes, this
                                           ##     value should always specify a count that when multiplied by 32
                                           ##     results in a multiple of bytesPerSector.  FAT16 volumes should
                                           ##     use the value 512.
                                           ##
    rootDirEntryCount* {.importc: "rootDirEntryCount".}: uint16 ## *
                                                              ##      This field is the old 16-bit total count of sectors on the volume.
                                                              ##      This count includes the count of all sectors in all four regions
                                                              ##      of the volume. This field can be 0; if it is 0, then totalSectors32
                                                              ##      must be non-zero.  For FAT32 volumes, this field must be 0. For
                                                              ##      FAT12 and FAT16 volumes, this field contains the sector count, and
                                                              ##      totalSectors32 is 0 if the total sector count fits
                                                              ##      (is less than 0x10000).
                                                              ##
    totalSectors16* {.importc: "totalSectors16".}: uint16 ## *
                                                        ##      This dates back to the old MS-DOS 1.x media determination and is
                                                        ##      no longer usually used for anything.  0xF8 is the standard value
                                                        ##      for fixed (non-removable) media. For removable media, 0xF0 is
                                                        ##      frequently used. Legal values are 0xF0 or 0xF8-0xFF.
                                                        ##
    mediaType* {.importc: "mediaType".}: uint8 ## *
                                             ##      Count of sectors occupied by one FAT on FAT12/FAT16 volumes.
                                             ##      On FAT32 volumes this field must be 0, and sectorsPerFat32
                                             ##      contains the FAT size count.
                                             ##
    sectorsPerFat16* {.importc: "sectorsPerFat16".}: uint16 ## * Sectors per track for interrupt 0x13. Not used otherwise.
    sectorsPerTrtack* {.importc: "sectorsPerTrtack".}: uint16 ## * Number of heads for interrupt 0x13.  Not used otherwise.
    headCount* {.importc: "headCount".}: uint16 ## *
                                              ##      Count of hidden sectors preceding the partition that contains this
                                              ##      FAT volume. This field is generally only relevant for media
                                              ##       visible on interrupt 0x13.
                                              ##
    hidddenSectors* {.importc: "hidddenSectors".}: uint32 ## *
                                                        ##      This field is the new 32-bit total count of sectors on the volume.
                                                        ##      This count includes the count of all sectors in all four regions
                                                        ##      of the volume.  This field can be 0; if it is 0, then
                                                        ##      totalSectors16 must be non-zero.
                                                        ##
    totalSectors32* {.importc: "totalSectors32".}: uint32 ## *
                                                        ##      Count of sectors occupied by one FAT on FAT32 volumes.
                                                        ##
    sectorsPerFat32* {.importc: "sectorsPerFat32".}: uint32 ## *
                                                          ##      This field is only defined for FAT32 media and does not exist on
                                                          ##      FAT12 and FAT16 media.
                                                          ##      Bits 0-3 -- Zero-based number of active FAT.
                                                          ##                  Only valid if mirroring is disabled.
                                                          ##      Bits 4-6 -- Reserved.
                                                          ##      Bit 7	-- 0 means the FAT is mirrored at runtime into all FATs.
                                                          ##             -- 1 means only one FAT is active; it is the one referenced in bits 0-3.
                                                          ##      Bits 8-15 	-- Reserved.
                                                          ##
    fat32Flags* {.importc: "fat32Flags".}: uint16 ## *
                                                ##      FAT32 version. High byte is major revision number.
                                                ##      Low byte is minor revision number. Only 0.0 define.
                                                ##
    fat32Version* {.importc: "fat32Version".}: uint16 ## *
                                                    ##      Cluster number of the first cluster of the root directory for FAT32.
                                                    ##      This usually 2 but not required to be 2.
                                                    ##
    fat32RootCluster* {.importc: "fat32RootCluster".}: uint32 ## *
                                                            ##      Sector number of FSINFO structure in the reserved area of the
                                                            ##      FAT32 volume. Usually 1.
                                                            ##
    fat32FSInfo* {.importc: "fat32FSInfo".}: uint16 ## *
                                                  ##      If non-zero, indicates the sector number in the reserved area
                                                  ##      of the volume of a copy of the boot record. Usually 6.
                                                  ##      No value other than 6 is recommended.
                                                  ##
    fat32BackBootBlock* {.importc: "fat32BackBootBlock".}: uint16 ## *
                                                                ##      Reserved for future expansion. Code that formats FAT32 volumes
                                                                ##      should always set all of the bytes of this field to 0.
                                                                ##
    fat32Reserved* {.importc: "fat32Reserved".}: array[12, uint8]


## * Type name for biosParmBlock

type
  bpb_t* = biosParmBlock

## ------------------------------------------------------------------------------
## *
##    \struct fat32BootSector
##
##    \brief Boot sector for a FAT16 or FAT32 volume.
##
##

type
  fat32BootSector* {.importcpp: "fat32BootSector", header: "FatStructs.h", bycopy.} = object ##
                                                                                     ## *
                                                                                     ## X86
                                                                                     ## jmp
                                                                                     ## to
                                                                                     ## boot
                                                                                     ## program
                                                                                     ##
                                                                                     ## __attribute__((packed))
    jmpToBootCode* {.importc: "jmpToBootCode".}: array[3, uint8] ## * informational only - don't depend on it
    oemName* {.importc: "oemName".}: array[8, char] ## * BIOS Parameter Block
    bpb* {.importc: "bpb".}: bpb_t ## * for int0x13 use value 0X80 for hard drive
    driveNumber* {.importc: "driveNumber".}: uint8 ## * used by Windows NT - should be zero for FAT
    reserved1* {.importc: "reserved1".}: uint8 ## * 0X29 if next three fields are valid
    bootSignature* {.importc: "bootSignature".}: uint8 ## * usually generated by combining date and time
    volumeSerialNumber* {.importc: "volumeSerialNumber".}: uint32 ## * should match volume label in root dir
    volumeLabel* {.importc: "volumeLabel".}: array[11, char] ## * informational only - don't depend on it
    fileSystemType* {.importc: "fileSystemType".}: array[8, char] ## * X86 boot code
    bootCode* {.importc: "bootCode".}: array[420, uint8] ## * must be 0X55
    bootSectorSig0* {.importc: "bootSectorSig0".}: uint8 ## * must be 0XAA
    bootSectorSig1* {.importc: "bootSectorSig1".}: uint8


## ------------------------------------------------------------------------------
##  End Of Chain values for FAT entries
## * FAT16 end of chain value used by Microsoft.

var FAT16EOC* {.importcpp: "FAT16EOC", header: "FatStructs.h".}: uint16

## * Minimum value for FAT16 EOC.  Use to test for EOC.

var FAT16EOC_MIN* {.importcpp: "FAT16EOC_MIN", header: "FatStructs.h".}: uint16

## * FAT32 end of chain value used by Microsoft.

var FAT32EOC* {.importcpp: "FAT32EOC", header: "FatStructs.h".}: uint32

## * Minimum value for FAT32 EOC.  Use to test for EOC.

var FAT32EOC_MIN* {.importcpp: "FAT32EOC_MIN", header: "FatStructs.h".}: uint32

## * Mask a for FAT32 entry. Entries are 28 bits.

var FAT32MASK* {.importcpp: "FAT32MASK", header: "FatStructs.h".}: uint32

## * Type name for fat32BootSector

type
  fbs_t* = fat32BootSector

## ------------------------------------------------------------------------------
## *
##    \struct directoryEntry
##    \brief FAT short directory entry
##
##    Short means short 8.3 name, not the entry size.
##
##    Date Format. A FAT directory entry date stamp is a 16-bit field that is
##    basically a date relative to the MS-DOS epoch of 01/01/1980. Here is the
##    format (bit 0 is the LSB of the 16-bit word, bit 15 is the MSB of the
##    16-bit word):
##
##    Bits 9-15: Count of years from 1980, valid value range 0-127
##    inclusive (1980-2107).
##
##    Bits 5-8: Month of year, 1 = January, valid value range 1-12 inclusive.
##
##    Bits 0-4: Day of month, valid value range 1-31 inclusive.
##
##    Time Format. A FAT directory entry time stamp is a 16-bit field that has
##    a granularity of 2 seconds. Here is the format (bit 0 is the LSB of the
##    16-bit word, bit 15 is the MSB of the 16-bit word).
##
##    Bits 11-15: Hours, valid value range 0-23 inclusive.
##
##    Bits 5-10: Minutes, valid value range 0-59 inclusive.
##
##    Bits 0-4: 2-second count, valid value range 0-29 inclusive (0 - 58 seconds).
##
##    The valid time range is from Midnight 00:00:00 to 23:59:58.
##

type
  directoryEntry* {.importcpp: "directoryEntry", header: "FatStructs.h", bycopy.} = object ## *
                                                                                   ##      Short 8.3 name.
                                                                                   ##      The first eight bytes contain the file name with blank fill.
                                                                                   ##      The last three bytes contain the file extension with blank fill.
                                                                                   ##
                                                                                   ##  __attribute__((packed))
    name* {.importc: "name".}: array[11, uint8] ## * Entry attributes.
                                             ##
                                             ##      The upper two bits of the attribute byte are reserved and should
                                             ##      always be set to 0 when a file is created and never modified or
                                             ##      looked at after that.  See defines that begin with DIR_ATT_.
                                             ##
    attributes* {.importc: "attributes".}: uint8 ## *
                                               ##      Reserved for use by Windows NT. Set value to 0 when a file is
                                               ##      created and never modify or look at it after that.
                                               ##
    reservedNT* {.importc: "reservedNT".}: uint8 ## *
                                               ##      The granularity of the seconds part of creationTime is 2 seconds
                                               ##      so this field is a count of tenths of a second and its valid
                                               ##      value range is 0-199 inclusive. (WHG note - seems to be hundredths)
                                               ##
    creationTimeTenths* {.importc: "creationTimeTenths".}: uint8 ## * Time file was created.
    creationTime* {.importc: "creationTime".}: uint16 ## * Date file was created.
    creationDate* {.importc: "creationDate".}: uint16 ## *
                                                    ##      Last access date. Note that there is no last access time, only
                                                    ##      a date.  This is the date of last read or write. In the case of
                                                    ##      a write, this should be set to the same date as lastWriteDate.
                                                    ##
    lastAccessDate* {.importc: "lastAccessDate".}: uint16 ## *
                                                        ##      High word of this entry's first cluster number (always 0 for a
                                                        ##      FAT12 or FAT16 volume).
                                                        ##
    firstClusterHigh* {.importc: "firstClusterHigh".}: uint16 ## * Time of last write. File creation is considered a write.
    lastWriteTime* {.importc: "lastWriteTime".}: uint16 ## * Date of last write. File creation is considered a write.
    lastWriteDate* {.importc: "lastWriteDate".}: uint16 ## * Low word of this entry's first cluster number.
    firstClusterLow* {.importc: "firstClusterLow".}: uint16 ## * 32-bit unsigned holding this file's size in bytes.
    fileSize* {.importc: "fileSize".}: uint32


## ------------------------------------------------------------------------------
##  Definitions for directory entries
##
## * Type name for directoryEntry

type
  dir_t* = directoryEntry

## * escape for name[0] = 0XE5

var DIR_NAME_0XE5* {.importcpp: "DIR_NAME_0XE5", header: "FatStructs.h".}: uint8

## * name[0] value for entry that is free after being "deleted"

var DIR_NAME_DELETED* {.importcpp: "DIR_NAME_DELETED", header: "FatStructs.h".}: uint8

## * name[0] value for entry that is free and no allocated entries follow

var DIR_NAME_FREE* {.importcpp: "DIR_NAME_FREE", header: "FatStructs.h".}: uint8

## * file is read-only

var DIR_ATT_READ_ONLY* {.importcpp: "DIR_ATT_READ_ONLY", header: "FatStructs.h".}: uint8

## * File should hidden in directory listings

var DIR_ATT_HIDDEN* {.importcpp: "DIR_ATT_HIDDEN", header: "FatStructs.h".}: uint8

## * Entry is for a system file

var DIR_ATT_SYSTEM* {.importcpp: "DIR_ATT_SYSTEM", header: "FatStructs.h".}: uint8

## * Directory entry contains the volume label

var DIR_ATT_VOLUME_ID* {.importcpp: "DIR_ATT_VOLUME_ID", header: "FatStructs.h".}: uint8

## * Entry is for a directory

var DIR_ATT_DIRECTORY* {.importcpp: "DIR_ATT_DIRECTORY", header: "FatStructs.h".}: uint8

## * Old DOS archive bit for backup support

var DIR_ATT_ARCHIVE* {.importcpp: "DIR_ATT_ARCHIVE", header: "FatStructs.h".}: uint8

## * Test value for long name entry.  Test is
##   (d->attributes & DIR_ATT_LONG_NAME_MASK) == DIR_ATT_LONG_NAME.

var DIR_ATT_LONG_NAME* {.importcpp: "DIR_ATT_LONG_NAME", header: "FatStructs.h".}: uint8

## * Test mask for long name entry

var DIR_ATT_LONG_NAME_MASK* {.importcpp: "DIR_ATT_LONG_NAME_MASK",
                            header: "FatStructs.h".}: uint8

## * defined attribute bits

var DIR_ATT_DEFINED_BITS* {.importcpp: "DIR_ATT_DEFINED_BITS",
                          header: "FatStructs.h".}: uint8

## * Directory entry is part of a long name

proc DIR_IS_LONG_NAME*(dir: ptr dir_t): uint8 =
  discard

## * Mask for file/subdirectory tests

var DIR_ATT_FILE_TYPE_MASK* {.importcpp: "DIR_ATT_FILE_TYPE_MASK",
                            header: "FatStructs.h".}: uint8

## * Directory entry is for a file

proc DIR_IS_FILE*(dir: ptr dir_t): uint8 =
  discard

## * Directory entry is for a subdirectory

proc DIR_IS_SUBDIR*(dir: ptr dir_t): uint8 =
  discard

## * Directory entry is for a file or subdirectory

proc DIR_IS_FILE_OR_SUBDIR*(dir: ptr dir_t): uint8 =
  discard
