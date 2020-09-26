##
##   Stream.h - base class for character-based streams.
##   Copyright (c) 2010 David A. Mellis.  All right reserved.
##
##   This library is free software; you can redistribute it and/or
##   modify it under the terms of the GNU Lesser General Public
##   License as published by the Free Software Foundation; either
##   version 2.1 of the License, or (at your option) any later version.
##
##   This library is distributed in the hope that it will be useful,
##   but WITHOUT ANY WARRANTY; without even the implied warranty of
##   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
##   Lesser General Public License for more details.
##
##   You should have received a copy of the GNU Lesser General Public
##   License along with this library; if not, write to the Free Software
##   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
##
##   parsing functions based on TextFinder library by Michael Margolis
##

import
  Print

##  compatability macros for testing
##
## #define   getInt()            parseInt()
## #define   getInt(ignore)    parseInt(ignore)
## #define   getFloat()          parseFloat()
## #define   getFloat(ignore)  parseFloat(ignore)
## #define   getString( pre_string, post_string, buffer, length)
## readBytesBetween( pre_string, terminator, buffer, length)
##
##  This enumeration provides the lookahead options for parseInt(), parseFloat()
##  The rules set out here are used until either the first valid character is found
##  or a time out occurs due to lack of input.

type
  LookaheadMode* = enum
    SKIP_ALL,                 ##  All invalid characters are ignored.
    SKIP_NONE,                ##  Nothing is skipped, and the stream is not touched unless the first waiting character is valid.
    SKIP_WHITESPACE           ##  Only tabs, spaces, line feeds & carriage returns are skipped.


const
  NO_IGNORE_CHAR* = '\x01'

type
  Stream* {.importcpp: "Stream", header: "Stream.h", bycopy.} = object of Print
    ##  number of milliseconds to wait for the next char before aborting timed read
    ##  used for timeout measurement


proc available*(this: var Stream): cint {.importcpp: "available", header: "Stream.h".}
proc read*(this: var Stream): cint {.importcpp: "read", header: "Stream.h".}
proc peek*(this: var Stream): cint {.importcpp: "peek", header: "Stream.h".}
proc constructStream*(): Stream {.constructor, importcpp: "Stream(@)", header: "Stream.h".}
proc setTimeout*(this: var Stream; timeout: culong) {.importcpp: "setTimeout", header: "Stream.h".}
proc getTimeout*(this: var Stream): culong {.importcpp: "getTimeout", header: "Stream.h".}
proc find*(this: var Stream; target: cstring): bool {.importcpp: "find", header: "Stream.h".}
proc find*(this: var Stream; target: ptr uint8): bool {.importcpp: "find", header: "Stream.h".}
proc find*(this: var Stream; target: cstring; length: csize_t): bool {.importcpp: "find", header: "Stream.h".}
proc find*(this: var Stream; target: ptr uint8; length: csize_t): bool {.importcpp: "find", header: "Stream.h".}
proc find*(this: var Stream; target: char): bool {.importcpp: "find", header: "Stream.h".}
proc findUntil*(this: var Stream; target: cstring; terminator: cstring): bool {. importcpp: "findUntil", header: "Stream.h".}
proc findUntil*(this: var Stream; target: ptr uint8; terminator: cstring): bool {. importcpp: "findUntil", header: "Stream.h".}
proc findUntil*(this: var Stream; target: cstring; targetLen: csize_t; terminate: cstring; termLen: csize_t): bool {.importcpp: "findUntil", header: "Stream.h".}
proc findUntil*(this: var Stream; target: ptr uint8; targetLen: csize_t; terminate: cstring; termLen: csize_t): bool {.importcpp: "findUntil", header: "Stream.h".}
proc parseInt*(this: var Stream; lookahead: LookaheadMode = SKIP_ALL; ignore: char = NO_IGNORE_CHAR): clong {.importcpp: "parseInt", header: "Stream.h".}
proc parseFloat*(this: var Stream; lookahead: LookaheadMode = SKIP_ALL; ignore: char = NO_IGNORE_CHAR): cfloat {.importcpp: "parseFloat", header: "Stream.h".}
proc readBytes*(this: var Stream; buffer: cstring; length: csize_t): csize_t {.importcpp: "readBytes", header: "Stream.h".}
proc readBytes*(this: var Stream; buffer: ptr uint8; length: csize_t): csize_t {.importcpp: "readBytes", header: "Stream.h".}
proc readBytesUntil*(this: var Stream; terminator: char; buffer: cstring; length: csize_t): csize_t {.importcpp: "readBytesUntil", header: "Stream.h".}
proc readBytesUntil*(this: var Stream; terminator: char; buffer: ptr uint8; length: csize_t): csize_t {.importcpp: "readBytesUntil", header: "Stream.h".}
# proc readString*(this: var Stream): cstring {.importcpp: "readString", header: "Stream.h".}
# proc readStringUntil*(this: var Stream; terminator: char): cstring {.importcpp: "readStringUntil", header: "Stream.h".}
