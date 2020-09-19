##  Arduino Sd2Card Library
##    Copyright (C) 2009 by William Greiman
##
##    This file is part of the Arduino Sd2Card Library
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
##    along with the Arduino Sd2Card Library.  If not, see
##    <http://www.gnu.org/licenses/>.
##

## *
##    \file
##    Sd2Card class
##

{. compile: "Sd2Card.cpp" .}
{. compile: "SdVolume.cpp" .}

import
  Sd2PinMap, SdInfo

## * Set SCK to max rate of F_CPU/2. See Sd2Card::setSckRate().

# var SPI_FULL_SPEED* {.importcpp: "SPI_FULL_SPEED", header: "Sd2Card.h".}: uint8

# ## * Set SCK rate to F_CPU/4. See Sd2Card::setSckRate().

# var SPI_HALF_SPEED* {.importcpp: "SPI_HALF_SPEED", header: "Sd2Card.h".}: uint8

# ## * Set SCK rate to F_CPU/8. Sd2Card::setSckRate().

# var SPI_QUARTER_SPEED* {.importcpp: "SPI_QUARTER_SPEED", header: "Sd2Card.h".}: uint8

## *
##    USE_SPI_LIB: if set, use the SPI library bundled with Arduino IDE, otherwise
##    run with a standalone driver for AVR.
##

const
  USE_SPI_LIB* = true

## *
##    Define MEGA_SOFT_SPI non-zero to use software SPI on Mega Arduinos.
##    Pins used are SS 10, MOSI 11, MISO 12, and SCK 13.
##
##    MEGA_SOFT_SPI allows an unmodified Adafruit GPS Shield to be used
##    on Mega Arduinos.  Software SPI works well with GPS Shield V1.1
##    but many SD cards will fail with GPS Shield V1.0.
##

const
  MEGA_SOFT_SPI* = 0

## ------------------------------------------------------------------------------

when MEGA_SOFT_SPI != 0 and
    (defined(AVR_ATmega1280) or defined(AVR_ATmega2560)):
  const
    SOFTWARE_SPI* = true
when not defined(SOFTWARE_SPI):
  ##  hardware pin defs
  ##  include pins_arduino.h or variant.h depending on architecture, via Arduino.h
  ## *
  ##   SD Chip Select pin
  ##
  ##   Warning if this pin is redefined the hardware SS will pin will be enabled
  ##   as an output by init().  An avr processor will not function as an SPI
  ##   master unless SS is set to output mode.
  ##
  when not defined(SDCARD_SS_PIN):
    ## * The default chip select pin for the SD card is SS.
    var SD_CHIP_SELECT_PIN* {.importcpp: "SD_CHIP_SELECT_PIN", header: "Sd2Card.h".}: uint8
  else:
    var SD_CHIP_SELECT_PIN* {.importcpp: "SD_CHIP_SELECT_PIN", header: "Sd2Card.h".}: uint8
  ##  The following three pins must not be redefined for hardware SPI,
  ##  so ensure that they are taken from pins_arduino.h or variant.h, depending on architecture.
  when not defined(SDCARD_MOSI_PIN):
    ## * SPI Master Out Slave In pin
    var SPI_MOSI_PIN* {.importcpp: "SPI_MOSI_PIN", header: "Sd2Card.h".}: uint8
    ## * SPI Master In Slave Out pin
    var SPI_MISO_PIN* {.importcpp: "SPI_MISO_PIN", header: "Sd2Card.h".}: uint8
    ## * SPI Clock pin
    var SPI_SCK_PIN* {.importcpp: "SPI_SCK_PIN", header: "Sd2Card.h".}: uint8
  else:
    var SPI_MOSI_PIN* {.importcpp: "SPI_MOSI_PIN", header: "Sd2Card.h".}: uint8
    var SPI_MISO_PIN* {.importcpp: "SPI_MISO_PIN", header: "Sd2Card.h".}: uint8
    var SPI_SCK_PIN* {.importcpp: "SPI_SCK_PIN", header: "Sd2Card.h".}: uint8
  ## * optimize loops for hardware SPI
  when not defined(USE_SPI_LIB):
    const
      OPTIMIZE_HARDWARE_SPI* = true
else:
  var SD_CHIP_SELECT_PIN* {.importcpp: "SD_CHIP_SELECT_PIN", header: "Sd2Card.h".}: uint8
  ## * SPI Master Out Slave In pin
  var SPI_MOSI_PIN* {.importcpp: "SPI_MOSI_PIN", header: "Sd2Card.h".}: uint8
  ## * SPI Master In Slave Out pin
  var SPI_MISO_PIN* {.importcpp: "SPI_MISO_PIN", header: "Sd2Card.h".}: uint8
  ## * SPI Clock pin
  var SPI_SCK_PIN* {.importcpp: "SPI_SCK_PIN", header: "Sd2Card.h".}: uint8
const
  SD_PROTECT_BLOCK_ZERO* = 1

## * init timeout ms

# var SD_INIT_TIMEOUT* {.importcpp: "SD_INIT_TIMEOUT", header: "Sd2Card.h".}: cuint

# ## * erase timeout ms

# var SD_ERASE_TIMEOUT* {.importcpp: "SD_ERASE_TIMEOUT", header: "Sd2Card.h".}: cuint

# ## * read timeout ms

# var SD_READ_TIMEOUT* {.importcpp: "SD_READ_TIMEOUT", header: "Sd2Card.h".}: cuint

# ## * write time out ms

# var SD_WRITE_TIMEOUT* {.importcpp: "SD_WRITE_TIMEOUT", header: "Sd2Card.h".}: cuint

## ------------------------------------------------------------------------------
##  SD card errors
## * timeout error for command CMD0

# var SD_CARD_ERROR_CMD0* {.importcpp: "SD_CARD_ERROR_CMD0", header: "Sd2Card.h".}: uint8

# ## * CMD8 was not accepted - not a valid SD card

# var SD_CARD_ERROR_CMD8* {.importcpp: "SD_CARD_ERROR_CMD8", header: "Sd2Card.h".}: uint8

# ## * card returned an error response for CMD17 (read block)

# var SD_CARD_ERROR_CMD17* {.importcpp: "SD_CARD_ERROR_CMD17", header: "Sd2Card.h".}: uint8

# ## * card returned an error response for CMD24 (write block)

# var SD_CARD_ERROR_CMD24* {.importcpp: "SD_CARD_ERROR_CMD24", header: "Sd2Card.h".}: uint8

# ## *  WRITE_MULTIPLE_BLOCKS command failed

# var SD_CARD_ERROR_CMD25* {.importcpp: "SD_CARD_ERROR_CMD25", header: "Sd2Card.h".}: uint8

# ## * card returned an error response for CMD58 (read OCR)

# var SD_CARD_ERROR_CMD58* {.importcpp: "SD_CARD_ERROR_CMD58", header: "Sd2Card.h".}: uint8

# ## * SET_WR_BLK_ERASE_COUNT failed

# var SD_CARD_ERROR_ACMD23* {.importcpp: "SD_CARD_ERROR_ACMD23", header: "Sd2Card.h".}: uint8

# ## * card's ACMD41 initialization process timeout

# var SD_CARD_ERROR_ACMD41* {.importcpp: "SD_CARD_ERROR_ACMD41", header: "Sd2Card.h".}: uint8

# ## * card returned a bad CSR version field

# var SD_CARD_ERROR_BAD_CSD* {.importcpp: "SD_CARD_ERROR_BAD_CSD", header: "Sd2Card.h".}: uint8

# ## * erase block group command failed

# var SD_CARD_ERROR_ERASE* {.importcpp: "SD_CARD_ERROR_ERASE", header: "Sd2Card.h".}: uint8

# ## * card not capable of single block erase

# var SD_CARD_ERROR_ERASE_SINGLE_BLOCK* {.importcpp: "SD_CARD_ERROR_ERASE_SINGLE_BLOCK",
#                                       header: "Sd2Card.h".}: uint8

# ## * Erase sequence timed out

# var SD_CARD_ERROR_ERASE_TIMEOUT* {.importcpp: "SD_CARD_ERROR_ERASE_TIMEOUT",
#                                  header: "Sd2Card.h".}: uint8

# ## * card returned an error token instead of read data

# var SD_CARD_ERROR_READ* {.importcpp: "SD_CARD_ERROR_READ", header: "Sd2Card.h".}: uint8

# ## * read CID or CSD failed

# var SD_CARD_ERROR_READ_REG* {.importcpp: "SD_CARD_ERROR_READ_REG",
#                             header: "Sd2Card.h".}: uint8

# ## * timeout while waiting for start of read data

# var SD_CARD_ERROR_READ_TIMEOUT* {.importcpp: "SD_CARD_ERROR_READ_TIMEOUT",
#                                 header: "Sd2Card.h".}: uint8

# ## * card did not accept STOP_TRAN_TOKEN

# var SD_CARD_ERROR_STOP_TRAN* {.importcpp: "SD_CARD_ERROR_STOP_TRAN",
#                              header: "Sd2Card.h".}: uint8

# ## * card returned an error token as a response to a write operation

# var SD_CARD_ERROR_WRITE* {.importcpp: "SD_CARD_ERROR_WRITE", header: "Sd2Card.h".}: uint8

# ## * attempt to write protected block zero

# var SD_CARD_ERROR_WRITE_BLOCK_ZERO* {.importcpp: "SD_CARD_ERROR_WRITE_BLOCK_ZERO",
#                                     header: "Sd2Card.h".}: uint8

# ## * card did not go ready for a multiple block write

# var SD_CARD_ERROR_WRITE_MULTIPLE* {.importcpp: "SD_CARD_ERROR_WRITE_MULTIPLE",
#                                   header: "Sd2Card.h".}: uint8

# ## * card returned an error to a CMD13 status check after a write

# var SD_CARD_ERROR_WRITE_PROGRAMMING* {.importcpp: "SD_CARD_ERROR_WRITE_PROGRAMMING",
#                                      header: "Sd2Card.h".}: uint8

# ## * timeout occurred during write programming

# var SD_CARD_ERROR_WRITE_TIMEOUT* {.importcpp: "SD_CARD_ERROR_WRITE_TIMEOUT",
#                                  header: "Sd2Card.h".}: uint8

# ## * incorrect rate selected

# var SD_CARD_ERROR_SCK_RATE* {.importcpp: "SD_CARD_ERROR_SCK_RATE",
#                             header: "Sd2Card.h".}: uint8

# ## ------------------------------------------------------------------------------
# ##  card types
# ## * Standard capacity V1 SD card

# var SD_CARD_TYPE_SD1* {.importcpp: "SD_CARD_TYPE_SD1", header: "Sd2Card.h".}: uint8

# ## * Standard capacity V2 SD card

# var SD_CARD_TYPE_SD2* {.importcpp: "SD_CARD_TYPE_SD2", header: "Sd2Card.h".}: uint8

# ## * High Capacity SD card

# var SD_CARD_TYPE_SDHC* {.importcpp: "SD_CARD_TYPE_SDHC", header: "Sd2Card.h".}: uint8

## ------------------------------------------------------------------------------
## *
##    \class Sd2Card
##    \brief Raw access to SD and SDHC flash memory cards.
##

type
  Sd2Card* {.importcpp: "Sd2Card", header: "Sd2Card.h", bycopy.} = object ## * Construct an instance of Sd2Card.
    ##  private functions


proc constructSd2Card*(): Sd2Card {.constructor, importcpp: "Sd2Card(@)",
                                 header: "Sd2Card.h".}
proc cardSize*(this: var Sd2Card): uint32 {.importcpp: "cardSize",
    header: "Sd2Card.h".}
proc erase*(this: var Sd2Card; firstBlock: uint32; lastBlock: uint32): uint8 {.
    importcpp: "erase", header: "Sd2Card.h".}
proc eraseSingleBlockEnable*(this: var Sd2Card): uint8 {.
    importcpp: "eraseSingleBlockEnable", header: "Sd2Card.h".}
proc errorCode*(this: Sd2Card): uint8 {.noSideEffect, importcpp: "errorCode",
                                      header: "Sd2Card.h".}
proc errorData*(this: Sd2Card): uint8 {.noSideEffect, importcpp: "errorData",
                                      header: "Sd2Card.h".}
proc init*(this: var Sd2Card): uint8 {.importcpp: "init", header: "Sd2Card.h".}
proc init*(this: var Sd2Card; sckRateID: uint8): uint8 {.importcpp: "init",header: "Sd2Card.h".}
proc init*(this: var Sd2Card; sckRateID: uint8; chipSelectPin: uint8): uint8 {.
    importcpp: "init", header: "Sd2Card.h".}
proc partialBlockRead*(this: var Sd2Card; value: uint8) {.
    importcpp: "partialBlockRead", header: "Sd2Card.h".}
proc partialBlockRead*(this: Sd2Card): uint8 {.noSideEffect,
    importcpp: "partialBlockRead", header: "Sd2Card.h".}
proc readBlock*(this: var Sd2Card; `block`: uint32; dst: ptr uint8): uint8 {.
    importcpp: "readBlock", header: "Sd2Card.h".}
proc readData*(this: var Sd2Card; `block`: uint32; offset: uint16; count: uint16;
              dst: ptr uint8): uint8 {.importcpp: "readData", header: "Sd2Card.h".}
proc readCID*(this: var Sd2Card; cid: ptr cid_t): uint8 {.importcpp: "readCID",
    header: "Sd2Card.h".}
proc readCSD*(this: var Sd2Card; csd: ptr csd_t): uint8 {.importcpp: "readCSD",
    header: "Sd2Card.h".}
proc readEnd*(this: var Sd2Card) {.importcpp: "readEnd", header: "Sd2Card.h".}
proc setSckRate*(this: var Sd2Card; sckRateID: uint8): uint8 {.
    importcpp: "setSckRate", header: "Sd2Card.h".}
proc `type`*(this: Sd2Card): uint8 {.noSideEffect, importcpp: "type",
                                   header: "Sd2Card.h".}
proc writeBlock*(this: var Sd2Card; blockNumber: uint32; src: ptr uint8;
                blocking: uint8 = 1): uint8 {.importcpp: "writeBlock",
    header: "Sd2Card.h".}
proc writeData*(this: var Sd2Card; src: ptr uint8): uint8 {.importcpp: "writeData",
    header: "Sd2Card.h".}
proc writeStart*(this: var Sd2Card; blockNumber: uint32; eraseCount: uint32): uint8 {.
    importcpp: "writeStart", header: "Sd2Card.h".}
proc writeStop*(this: var Sd2Card): uint8 {.importcpp: "writeStop",
    header: "Sd2Card.h".}
proc isBusy*(this: var Sd2Card): uint8 {.importcpp: "isBusy", header: "Sd2Card.h".}
