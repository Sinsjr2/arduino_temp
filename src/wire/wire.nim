##
##   TwoWire.h - TWI/I2C library for Arduino & Wiring
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
##   Modified 2012 by Todd Krein (todd@krein.org) to implement repeated starts
##   Modified 2020 by Greyson Christoforo (grey@christoforo.net) to implement timeouts
##

import utility/twi

const
  BUFFER_LENGTH* = 32'u8

##  WIRE_HAS_END means Wire has end()

const
  WIRE_HAS_END* = 1

type
  TwoWire* {.bycopy.} = object
    rxBuffer : array[BUFFER_LENGTH, uint8]
    rxBufferIndex : uint8
    rxBufferLength : uint8

    txAddress : uint8
    txBuffer : array[BUFFER_LENGTH, uint8]
    txBufferIndex : uint8
    txBufferLength : uint8

    transmitting  : bool

  #  static void (*user_onRequest)(void);
  #  static void (*user_onReceive)(int);

proc constructTwoWire*(): TwoWire {.constructor.} =
  TwoWire()

proc begin*(this: var TwoWire) =
  this.rxBufferIndex = 0
  this.rxBufferLength = 0

  this.txBufferIndex = 0;
  this.txBufferLength = 0;

  twi_init();


proc begin*(this: var TwoWire; address: uint8) =
  this.begin()
  twi_setAddress(address)


proc `end`*(this: var TwoWire) =
  twi_disable()

proc setClock*(this: var TwoWire; clock: uint32) =
  twi_setFrequency(clock)

proc setWireTimeout*(this: var TwoWire; timeout: uint32 = 25000;
                    resetWithTimeout: bool = false) =
  ##
  ## Sets the TWI timeout.
  ##
  ## This limits the maximum time to wait for the TWI hardware. If more time passes, the bus is assumed
  ## to have locked up (e.g. due to noise-induced glitches or faulty slaves) and the transaction is aborted.
  ## Optionally, the TWI hardware is also reset, which can be required to allow subsequent transactions to
  ## succeed in some cases (in particular when noise has made the TWI hardware think there is a second
  ## master that has claimed the bus).
  ##
  ## When a timeout is triggered, a flag is set that can be queried with `getWireTimeoutFlag()` and is cleared
  ## when `clearWireTimeoutFlag()` or `setWireTimeoutUs()` is called.
  ##
  ## Note that this timeout can also trigger while waiting for clock stretching or waiting for a second master
  ## to complete its transaction. So make sure to adapt the timeout to accomodate for those cases if needed.
  ## A typical timeout would be 25ms (which is the maximum clock stretching allowed by the SMBus protocol),
  ## but (much) shorter values will usually also work.
  ##
  ## In the future, a timeout will be enabled by default, so if you require the timeout to be disabled, it is
  ## recommended you disable it by default using `setWireTimeoutUs(0)`, even though that is currently
  ## the default.
  ##
  ## @param timeout a timeout value in microseconds, if zero then timeout checking is disabled
  ## @param reset_with_timeout if true then TWI interface will be automatically reset on timeout
  ##                           if false then TWI interface will not be reset on timeout
  twi_setTimeoutInMicros(timeout, resetWithTimeout)


proc getWireTimeoutFlag*(this: var TwoWire): bool =
  ## Returns the TWI timeout flag.
  ##
  ## @return true if timeout has occured since the flag was last cleared.
  return twi_manageTimeoutFlag(false)


proc clearWireTimeoutFlag*(this: var TwoWire) =
  ## Clears the TWI timeout flag.
  discard twi_manageTimeoutFlag(true)


proc beginTransmission*(this: var TwoWire; address: uint8) =
  # indicate that we are transmitting
  this.transmitting = true;
  # set address of targeted slave
  this.txAddress = address;
  # reset tx buffer iterator vars
  this.txBufferIndex = 0;
  this.txBufferLength = 0;


proc endTransmission*(this: var TwoWire; sendStop : uint8): uint8 =
  ## Originally, 'endTransmission' was an f(void) function.
  ## It has been modified to take one parameter indicating
  ## whether or not a STOP should be performed on the bus.
  ## Calling endTransmission(false) allows a sketch to 
  ## perform a repeated start. 
  ## 
  ## WARNING: Nothing in the library keeps track of whether
  ## the bus tenure has been properly ended with a STOP. It
  ## is very possible to leave the bus in a hung state if
  ## no call to endTransmission(true) is made. Some I2C
  ## devices will behave oddly if they do not see a STOP.

  let one : uint8 = 1
  # transmit buffer (blocking)
  let ret = twi_writeTo(this.txAddress, this.txBuffer, this.txBufferLength, one, sendStop);
  # reset tx buffer iterator vars
  this.txBufferIndex = 0;
  this.txBufferLength = 0;
  # indicate that we are done transmitting
  this.transmitting = false;
  return ret;

proc write*(this: var TwoWire; data: uint8): uint8

proc requestFrom*(this: var TwoWire; address: uint8; quantity: uint8; iaddress: uint8; isize: uint8; sendStop: uint8): uint8 =
  if isize > 0 :
    # send internal address; this mode allows sending a repeated start to access
    # some devices' internal registers. This function is executed by the hardware
    # TWI module on other processors (for example Due's TWI_IADR and TWI_MMR registers)

    this.beginTransmission(address)

    # the maximum size of internal address is 3 bytes
    var s =
      if isize > 3 :
        3'u8
      else :
        isize

    # write internal register address - most significant byte first
    while s > 0:
      s -= 1
      discard this.write(iaddress shr (s * 8'u8))

    discard this.endTransmission(0'u8)

  # clamp to buffer length
  var q =
    if quantity > BUFFER_LENGTH :
      BUFFER_LENGTH
    else:
      quantity

  # perform blocking read into buffer
  let read = twi_readFrom(address, this.rxBuffer, quantity, sendStop)
  # set rx buffer iterator vars
  this.rxBufferIndex = 0
  this.rxBufferLength = read

  return read;


proc requestFrom*(this: var TwoWire; address: uint8; quantity: uint8; sendStop: uint8): uint8 =
  return this.requestFrom(address, quantity, 0'u8, 0'u8, sendStop)


proc requestFrom*(this: var TwoWire; address: uint8; quantity: uint8): uint8 =
  return this.requestFrom(address, quantity, 0'u8, 0'u8, 1)


proc write*(this: var TwoWire; data: uint8): uint8 =
  ## must be called in:
  ## slave tx event callback
  ## or after beginTransmission(address)
  if this.transmitting:
    # in master transmitter mode
    # don't bother if buffer is full
    if this.txBufferLength >= BUFFER_LENGTH:
      # setWriteError()
      return 0;

    # put byte in tx buffer
    this.txBuffer[this.txBufferIndex] = data;
    this.txBufferIndex += 1
    # update amount in buffer   
    this.txBufferLength = this.txBufferIndex;
  else :
    # in slave send mode
    # reply to master
    discard twi_transmit([data], 1'u8)
  return 1;


# proc write*(this: var TwoWire; a2: ptr uint8; a3: csize): csize
proc available*(this: var TwoWire): uint8 =
  ## must be called in:
  ## slave rx event callback
  ## or after requestFrom(address, numBytes)
  return this.rxBufferLength - this.rxBufferIndex;


proc read*(this: var TwoWire): uint8 =
  ## must be called in:
  ## slave rx event callback
  ## or after requestFrom(address, numBytes)
  
  # get each successive byte on each call
  if this.rxBufferIndex < this.rxBufferLength:
    let val = this.rxBuffer[this.rxBufferIndex];
    this.rxBufferIndex += 1;
    return val
  return 0

# proc peek*(this: var TwoWire): cint
# proc flush*(this: var TwoWire)
# proc onReceive*(this: var TwoWire; a2: proc (a1: cint))
# proc onRequest*(this: var TwoWire; a2: proc ())
# proc write*(this: var TwoWire; n: culong): csize
# proc write*(this: var TwoWire; n: clong): csize
# proc write*(this: var TwoWire; n: cuint): csize
# proc write*(this: var TwoWire; n: cint): csize
var Wire*: TwoWire
