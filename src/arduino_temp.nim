import arduino
import wire/wire as w
import sd/SD as s
# import sd/utility/Sd2Card as c
import strutils


#var rxbuf: string = ""
#var newData: bool = false
# var myFile: s.File

# proc recvWithEndMarker() =
#   while Serial.available > 0:
#     # let c = Serial.read().char
#     let c = 'h'
#     rxbuf.add('g')
#     if true:
#       Serial.println "rxbuf"
#       return
#     if c == '\n':
#       newData = true

# proc showNewData() =
#   if newData:
#     Serial.println "This just in ... "
#     Serial.println "rxbuf"
#     newData = false
#     rxbuf = "ccccccc"

# proc writeToFile(file : var s.File; str: string) =
#   for c in str:
#     discard Serial.write(cast[uint8](c))
#     discard file.write(cast[byte](c))
    
# proc setupSD(): bool =
#   if not s.SDc.begin(4):
#     Serial.println("initialization failed!");
#     return false
#   Serial.println "SD initialized"
#   return true

proc readI2CTemplature() : float =
  ## i2c経由で温度センサの値を読み込みます。
  discard w.Wire.requestFrom(0x49'u8, 2'u8)
  var temp = 0'u16;
  while 0'u8 < w.Wire.available():
    let b = Wire.read();
    temp = temp shl 8'u8;
    temp = temp or b;

  return temp.float / 128.0f

proc hoge =
  Serial.begin 9600
  Serial.println "<Arduino is ready>1"
  Serial.println "<Arduino is ready>2"
  Serial.println "<Arduino is ready>3"
  Serial.println "<Arduino is ready>4"
  Serial.println "<Arduino is ready>5"
  Serial.println "<Arduino is ready>6"
  Serial.println "<Arduino is ready>7"
  Serial.println "<Arduino is ready>8"
  Serial.println "<Arduino is ready>9"
  Serial.println "<Arduino is ready>10"
  Serial.println "<Arduino is ready>11"
  Serial.flush()
  # Serial.println "<Arduino is ready>12"
  # delayMicroseconds 9999
  # delayMicroseconds 9999
  # let isOk = s.SDc.begin(4)
  # if (not s.SDc.begin(4)):
  #   return


setup:
  Serial.begin 9600
  Serial.println "<Arduino is ready>"
  if (not s.SDc.begin(4)):
    return
  # hoge()

  Serial.println "SD initialized"
  var myFile = s.SDc.open("test.txt", s.FILE_READ)
  if (not myFile):
    Serial.println("error opening test.txt");
    return

  while (myFile.available() != 0):
    discard Serial.write(cast[uint8](myFile.read()))

  w.Wire.begin()
  # Serial.println "SD initialized"


  # let filename = "/test.txt";
  # Serial.println( if s.SDc.exists(filename):
  #                   "true"
  #                 else :
  #                   "false")

  # # Serial.println(myFile.size())
  # Serial.println(myFile.available().intToStr())
  # while (myFile.available() != 0):
  #   discard Serial.write(cast[uint8](myFile.read()));

proc printStr(str : string) =
  for c in str:
    discard Serial.write(cast[uint8](c))

loop:
  # var temp = 0'u16;
  # # while 0'u8 < w.Wire.available():
  # #   let b = Wire.read();
  # #   temp = temp shl 8'u8;
  # #   temp = temp or b;
  # Serial.println "laap"
  # Serial.flush()
  # let value = 0.0f < (17.0f / 128.0f)

  # Serial.println("eeeee")
  # printStr(if value:
  #            "true"
  #          else:
  #            "cold")
  # Serial.println("loop")
  # Serial.println(if value:
  #                  ""
  #                else:
  #                  "cold")

  discard Serial.print(readI2CTemplature(), 10'u8)
  Serial.println("")
  delay(1000)
  # recvWithEndMarker()
  # showNewData()

