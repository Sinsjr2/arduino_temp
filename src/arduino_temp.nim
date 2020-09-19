import arduino
import sd/SD as s
# import sd/utility/Sd2Card as c
# import strutils

# proc fdevopen*(put: proc (a1: char; a2: FILE): cint {.cdecl.};
#                get: proc (a1: FILE): cint {.cdecl.} ): FILE {.importcpp: "fdevopen(@)", header: "stdio.h".}


# template setup*(code: untyped) =
#   proc setup*() {.exportc.} =
#     # stdout = fdevopen(myputchar, nil)
#     code 

# template loop*(code: untyped) =
#   proc loop*() {.exportc.} =
#     code 


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

setup:
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
  # Serial.flush()
  # Serial.println "<Arduino is ready>12"
  # delayMicroseconds 9999
  # delayMicroseconds 9999
  # let isOk = s.SDc.begin(4)
  if (not s.SDc.begin(4)):
    return
  Serial.println "SD initialized"
  var myFile = s.SDc.open("test.txt", s.FILE_READ)
  while (myFile.available() != 0):
    discard Serial.write(cast[uint8](myFile.read()))

  # if not s.SDc.begin(4):
  #   Serial.println("initialization failed!");
  #   return
  # Serial.println "SD initialized"


  # let filename = "/test.txt";
  # Serial.println( if s.SDc.exists(filename):
  #                   "true"
  #                 else :
  #                   "false")

  # var myFile = s.SDc.open(filename, s.FILE_READ)
  # if (not myFile):
  #   Serial.println("error opening test.txt");
  #   return

  # # myFile.writeToFile("kkkkkkskskkskskksk");

  # # Serial.println(myFile.size())
  # Serial.println(myFile.available().intToStr())
  # return
  # while (myFile.available() != 0):
  #   discard Serial.write(cast[uint8](myFile.read()));

loop:
  Serial.println "loop"
  delay(1000)
  # recvWithEndMarker()
  # showNewData()

