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

##  Based on the document:
##
##  SD Specifications
##  Part 1
##  Physical Layer
##  Simplified Specification
##  Version 2.00
##  September 25, 2006
##
##  www.sdcard.org/developers/tech/sdcard/pls/Simplified_Physical_Layer_Spec.pdf
## ------------------------------------------------------------------------------
##  SD card commands
## * GO_IDLE_STATE - init card in spi mode if CS low

const CMD0*: uint8 = 0x00000000

## * SEND_IF_COND - verify SD Memory Card interface operating condition.

const CMD8*: uint8 = 0x00000008

## * SEND_CSD - read the Card Specific Data (CSD register)

const CMD9*: uint8 = 0x00000009

## * SEND_CID - read the card identification information (CID register)

const CMD10*: uint8 = 0x0000000A

## * SEND_STATUS - read the card status register

const CMD13*: uint8 = 0x0000000D

## * READ_BLOCK - read a single data block from the card

const CMD17*: uint8 = 0x00000011

## * WRITE_BLOCK - write a single data block to the card

const CMD24*: uint8 = 0x00000018

## * WRITE_MULTIPLE_BLOCK - write blocks of data until a STOP_TRANSMISSION

const CMD25*: uint8 = 0x00000019

## * ERASE_WR_BLK_START - sets the address of the first block to be erased

const CMD32*: uint8 = 0x00000020

## * ERASE_WR_BLK_END - sets the address of the last block of the continuous
##     range to be erased

const CMD33*: uint8 = 0x00000021

## * ERASE - erase all previously selected blocks

const CMD38*: uint8 = 0x00000026

## * APP_CMD - escape for application specific command

const CMD55*: uint8 = 0x00000037

## * READ_OCR - read the OCR register of a card

const CMD58*: uint8 = 0x0000003A

## * SET_WR_BLK_ERASE_COUNT - Set the number of write blocks to be
##      pre-erased before writing

const ACMD23*: uint8 = 0x00000017

## * SD_SEND_OP_COMD - Sends host capacity support information and
##     activates the card's initialization process

const ACMD41*: uint8 = 0x00000029

## ------------------------------------------------------------------------------
## * status for card in the ready state

const R1_READY_STATE*: uint8 = 0x00000000

## * status for card in the idle state

const R1_IDLE_STATE*: uint8 = 0x00000001

## * status bit for illegal command

const R1_ILLEGAL_COMMAND*: uint8 = 0x00000004

## * start data token for read or write single block

const DATA_START_BLOCK*: uint8 = 0x000000FE

## * stop token for write multiple blocks

const STOP_TRAN_TOKEN*: uint8 = 0x000000FD

## * start data token for write multiple blocks

const WRITE_MULTIPLE_TOKEN*: uint8 = 0x000000FC

## * mask for data response tokens after a write block operation

const DATA_RES_MASK*: uint8 = 0x0000001F

## * write data accepted token

const DATA_RES_ACCEPTED*: uint8 = 0x00000005

## ------------------------------------------------------------------------------

type
  cid_t* {.bycopy.} = object
    mid*: uint8              ##  byte 0
    ##  Manufacturer ID
    ##  byte 1-2
    oid*: array[2, char]        ##  OEM/Application ID
                      ##  byte 3-7
    pnm*: array[5, char]        ##  Product name
                      ##  byte 8
    prv_m* {.bitsize: 4.}: cuint ##  Product revision n.m
    prv_n* {.bitsize: 4.}: cuint ##  byte 9-12
    psn*: uint32             ##  Product serial number
                 ##  byte 13
    mdt_year_high* {.bitsize: 4.}: cuint ##  Manufacturing date
    reserved* {.bitsize: 4.}: cuint ##  byte 14
    mdt_month* {.bitsize: 4.}: cuint
    mdt_year_low* {.bitsize: 4.}: cuint ##  byte 15
    always1* {.bitsize: 1.}: cuint
    crc* {.bitsize: 7.}: cuint


## ------------------------------------------------------------------------------
##  CSD for version 1.00 cards

type
  csd1_t* {.bycopy.} = object
    reserved1* {.bitsize: 6.}: cuint ##  byte 0
    csd_ver* {.bitsize: 2.}: cuint ##  byte 1
    taac*: uint8             ##  byte 2
    nsac*: uint8             ##  byte 3
    tran_speed*: uint8       ##  byte 4
    ccc_high*: uint8         ##  byte 5
    read_bl_len* {.bitsize: 4.}: cuint
    ccc_low* {.bitsize: 4.}: cuint ##  byte 6
    c_size_high* {.bitsize: 2.}: cuint
    reserved2* {.bitsize: 2.}: cuint
    dsr_imp* {.bitsize: 1.}: cuint
    read_blk_misalign* {.bitsize: 1.}: cuint
    write_blk_misalign* {.bitsize: 1.}: cuint
    read_bl_partial* {.bitsize: 1.}: cuint ##  byte 7
    c_size_mid*: uint8       ##  byte 8
    vdd_r_curr_max* {.bitsize: 3.}: cuint
    vdd_r_curr_min* {.bitsize: 3.}: cuint
    c_size_low* {.bitsize: 2.}: cuint ##  byte 9
    c_size_mult_high* {.bitsize: 2.}: cuint
    vdd_w_cur_max* {.bitsize: 3.}: cuint
    vdd_w_curr_min* {.bitsize: 3.}: cuint ##  byte 10
    sector_size_high* {.bitsize: 6.}: cuint
    erase_blk_en* {.bitsize: 1.}: cuint
    c_size_mult_low* {.bitsize: 1.}: cuint ##  byte 11
    wp_grp_size* {.bitsize: 7.}: cuint
    sector_size_low* {.bitsize: 1.}: cuint ##  byte 12
    write_bl_len_high* {.bitsize: 2.}: cuint
    r2w_factor* {.bitsize: 3.}: cuint
    reserved3* {.bitsize: 2.}: cuint
    wp_grp_enable* {.bitsize: 1.}: cuint ##  byte 13
    reserved4* {.bitsize: 5.}: cuint
    write_partial* {.bitsize: 1.}: cuint
    write_bl_len_low* {.bitsize: 2.}: cuint ##  byte 14
    reserved5* {.bitsize: 2.}: cuint
    file_format* {.bitsize: 2.}: cuint
    tmp_write_protect* {.bitsize: 1.}: cuint
    perm_write_protect* {.bitsize: 1.}: cuint
    copy* {.bitsize: 1.}: cuint
    file_format_grp* {.bitsize: 1.}: cuint ##  byte 15
    always1* {.bitsize: 1.}: cuint
    crc* {.bitsize: 7.}: cuint


## ------------------------------------------------------------------------------
##  CSD for version 2.00 cards

type
  csd2_t* {.bycopy.} = object
    reserved1* {.bitsize: 6.}: cuint ##  byte 0
    csd_ver* {.bitsize: 2.}: cuint ##  byte 1
    taac*: uint8             ##  byte 2
    nsac*: uint8             ##  byte 3
    tran_speed*: uint8       ##  byte 4
    ccc_high*: uint8         ##  byte 5
    read_bl_len* {.bitsize: 4.}: cuint
    ccc_low* {.bitsize: 4.}: cuint ##  byte 6
    reserved2* {.bitsize: 4.}: cuint
    dsr_imp* {.bitsize: 1.}: cuint
    read_blk_misalign* {.bitsize: 1.}: cuint
    write_blk_misalign* {.bitsize: 1.}: cuint
    read_bl_partial* {.bitsize: 1.}: cuint ##  byte 7
    reserved3* {.bitsize: 2.}: cuint
    c_size_high* {.bitsize: 6.}: cuint ##  byte 8
    c_size_mid*: uint8       ##  byte 9
    c_size_low*: uint8       ##  byte 10
    sector_size_high* {.bitsize: 6.}: cuint
    erase_blk_en* {.bitsize: 1.}: cuint
    reserved4* {.bitsize: 1.}: cuint ##  byte 11
    wp_grp_size* {.bitsize: 7.}: cuint
    sector_size_low* {.bitsize: 1.}: cuint ##  byte 12
    write_bl_len_high* {.bitsize: 2.}: cuint
    r2w_factor* {.bitsize: 3.}: cuint
    reserved5* {.bitsize: 2.}: cuint
    wp_grp_enable* {.bitsize: 1.}: cuint ##  byte 13
    reserved6* {.bitsize: 5.}: cuint
    write_partial* {.bitsize: 1.}: cuint
    write_bl_len_low* {.bitsize: 2.}: cuint ##  byte 14
    reserved7* {.bitsize: 2.}: cuint
    file_format* {.bitsize: 2.}: cuint
    tmp_write_protect* {.bitsize: 1.}: cuint
    perm_write_protect* {.bitsize: 1.}: cuint
    copy* {.bitsize: 1.}: cuint
    file_format_grp* {.bitsize: 1.}: cuint ##  byte 15
    always1* {.bitsize: 1.}: cuint
    crc* {.bitsize: 7.}: cuint


## ------------------------------------------------------------------------------
##  union of old and new style CSD register

type
  csd_t* {.bycopy.} = object {.union.}
    v1*: csd1_t
    v2*: csd2_t

