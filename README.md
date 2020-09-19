### ビルドと書き込みコマンド
```
nimble build && avr-objcopy -O ihex -R .eeprom bin/arduino_temp.elf bin/arduino_temp.hex && avr-size bin/arduino_temp.elf &&  avrdude -D  -c arduino -C ~/Downloads/arduino-1.8.13-linux64/arduino-1.8.13/hardware/tools/avr/etc/avrdude.conf -p ATMEGA328P -V -P /dev/ttyUSB0  -b 57600 -U flash:w:bin/arduino_temp.hex
```
