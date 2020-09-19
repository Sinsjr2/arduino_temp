##  Arduino SdFat Library
##    Copyright (C) 2008 by William Greiman
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
##    Useful utility functions.
##

type
  PGM_P* = ptr[char]

when defined(AVR):
  ## * Store and print a string in flash memory.
  template PgmPrint*(x: untyped): untyped =
    SerialPrint_P(PSTR(x))

  ## * Store and print a string in flash memory followed by a CR/LF.
  template PgmPrintln*(x: untyped): untyped =
    SerialPrintln_P(PSTR(x))

  ## * Defined so doxygen works for function definitions.
# const
#   NOINLINE* = __attribute__((
#     noinline
#     unused))
#   UNUSEDOK* = __attribute__((unused))

## ------------------------------------------------------------------------------
## * Return the number of bytes currently free in RAM.

proc FreeRam*(): cint =
  discard

when defined(AVR):
  ## ------------------------------------------------------------------------------
  ## *
  ##    %Print a string in flash memory to the serial port.
  ##
  ##    \param[in] str Pointer to string stored in flash memory.
  ##
  proc SerialPrint_P*(str: PGM_P) =
    discard

  ## ------------------------------------------------------------------------------
  ## *
  ##    %Print a string in flash memory followed by a CR/LF.
  ##
  ##    \param[in] str Pointer to string stored in flash memory.
  ##
  proc SerialPrintln_P*(str: PGM_P) =
    discard
