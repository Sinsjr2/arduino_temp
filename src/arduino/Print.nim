##
##   Print.h - Base class that provides print() and println()
##   Copyright (c) 2008 David A. Mellis.  All right reserved.
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

# import
#   WString, Printable

const
  DEC* = 10
  HEX* = 16
  OCT* = 8

when defined(BIN):             ##  Prevent warnings if BIN is previously defined in "iotnx4.h" or similar
  const
    BIN* = 2

type
  Print* {.importcpp: "Print", header: "Print.h", bycopy, inheritable .} = object


proc constructPrint*(): Print {.constructor, importcpp: "Print(@)", header: "Print.h".}
proc getWriteError*(this: var Print): cint {.importcpp: "getWriteError", header: "Print.h".}
proc clearWriteError*(this: var Print) {.importcpp: "clearWriteError", header: "Print.h".}
proc write*(this: var Print; a2: uint8): csize_t {.importcpp: "write", header: "Print.h".}
proc write*(this: var Print; str: cstring): csize_t {.importcpp: "write", header: "Print.h".}
# proc write*(this: var Print; buffer: ptr uint8; size: csize_t): csize_t {.importcpp: "write", header: "Print.h".}
proc write*(this: var Print; buffer: cstring; size: csize_t): csize_t {.importcpp: "write", header: "Print.h".}
proc availableForWrite*(this: var Print): cint {.importcpp: "availableForWrite", header: "Print.h".}
# proc print*(this: var Print; a2: ptr __FlashStringHelper): csize_t {.importcpp: "print", header: "Print.h".}
proc print*(this: var Print; a2: cstring): csize_t {.importcpp: "print", header: "Print.h".}
# proc print*(this: var Print; a2: ptr char): csize_t {.importcpp: "print", header: "Print.h".}
proc print*(this: var Print; a2: int8): csize_t {.importcpp: "print", header: "Print.h".}
proc print*(this: var Print; a2: uint8; a3: cint = DEC): csize_t {.importcpp: "print", header: "Print.h".}
proc print*(this: var Print; a2: int16; a3: cint = DEC): csize_t {.importcpp: "print", header: "Print.h".}
proc print*(this: var Print; a2: uint16; a3: cint = DEC): csize_t {.importcpp: "print", header: "Print.h".}
proc print*(this: var Print; a2: int32; a3: cint = DEC): csize_t {.importcpp: "print", header: "Print.h".}
proc print*(this: var Print; a2: uint32; a3: cint = DEC): csize_t {.importcpp: "print", header: "Print.h".}
proc print*(this: var Print; a2: float; a3: cint = 2): csize_t {.importcpp: "print", header: "Print.h".}
# proc print*(this: var Print; a2: Printable): csize_t {.importcpp: "print", header: "Print.h".}
# proc println*(this: var Print; a2: ptr __FlashStringHelper): csize_t {. importcpp: "println", header: "Print.h".}
proc println*(this: var Print; s: cstring): csize_t {.importcpp: "println", header: "Print.h".}
proc println*(this: var Print; a2: ptr char): csize_t {.importcpp: "println", header: "Print.h".}
proc println*(this: var Print; a2: char): csize_t {.importcpp: "println", header: "Print.h".}
proc println*(this: var Print; a2: cuchar; a3: cint = DEC): csize_t {.importcpp: "println", header: "Print.h".}
proc println*(this: var Print; a2: cint; a3: cint = DEC): csize_t {.importcpp: "println", header: "Print.h".}
proc println*(this: var Print; a2: cuint; a3: cint = DEC): csize_t {.importcpp: "println",header: "Print.h".}
proc println*(this: var Print; a2: clong; a3: cint = DEC): csize_t {.importcpp: "println",header: "Print.h".}
proc println*(this: var Print; a2: culong; a3: cint = DEC): csize_t {.importcpp: "println", header: "Print.h".}
proc println*(this: var Print; a2: cdouble; a3: cint = 2): csize_t {.importcpp: "println", header: "Print.h".}
# proc println*(this: var Print; a2: Printable): csize_t {.importcpp: "println", header: "Print.h".}
proc println*(this: var Print): csize_t {.importcpp: "println", header: "Print.h".}
proc flush*(this: var Print) {.importcpp: "flush", header: "Print.h".}
