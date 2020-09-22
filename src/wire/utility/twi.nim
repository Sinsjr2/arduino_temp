##
##   twi.h - TWI/I2C library for Wiring & Arduino
##   Copyright (c) 2006 Nicholas Zambetti.  All right reserved.
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
##   Modified 2020 by Greyson Christoforo (grey@christoforo.net) to implement timeouts
##

{. compile: "twi.c" .}

const
  TWI_READY* = 0
  TWI_MRX* = 1
  TWI_MTX* = 2
  TWI_SRX* = 3
  TWI_STX* = 4


proc twi_init*() {.importc: "twi_init", header: "twi.h".}
proc twi_disable*() {.importc: "twi_disable", header: "twi.h".}
proc twi_setAddress*(a1: uint8) {.importc: "twi_setAddress", header: "twi.h".}
proc twi_setFrequency*(a1: uint32) {.importc: "twi_setFrequency", header: "twi.h".}
proc twi_readFrom*[size: static[uint8]](a1: uint8; a2: array[size, uint8]; a3: uint8; a4: uint8): uint8 {.importc: "twi_readFrom", header: "twi.h".}
proc twi_writeTo*[size: static[uint8]](a1: uint8; a2: array[size, uint8]; a3: uint8; a4: uint8; a5: uint8): uint8 {.importc: "twi_writeTo", header: "twi.h".}
proc twi_transmit*[size: static[uint8]](a1: array[size, uint8]; a2: uint8): uint8 {.importc: "twi_transmit", header: "twi.h".}
# proc twi_attachSlaveRxEvent*(a1: proc (a1: ptr uint8; a2: cint))
# proc twi_attachSlaveTxEvent*(a1: proc ())
proc twi_reply*(a1: uint8) {.importc: "twi_reply", header: "twi.h".}
proc twi_stop*() {.importc: "twi_stop", header: "twi.h".}
proc twi_releaseBus*() {.importc: "twi_releaseBus", header: "twi.h".}
proc twi_setTimeoutInMicros*(a1: uint32; a2: bool) {.importc: "twi_setTimeoutInMicros", header: "twi.h".}
proc twi_handleTimeout*(a1: bool) {.importc: "twi_handleTimeout", header: "twi.h".}
proc twi_manageTimeoutFlag*(a1: bool): bool {.importc: "twi_manageTimeoutFlag", header: "twi.h".}
