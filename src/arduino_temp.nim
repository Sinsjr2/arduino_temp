import arduino
import wire/wire as w
import sd/SD as s
# import sd/utility/Sd2Card as c
import strutils

const GMT_TOKYO* : uint32 = 9*60*60
const SECONDS_IN_A_DAY* =  24*60*60
const EPOCH_DAY*          = (1969 * 365) + (1969 div 4) - (1969 div 100) + (1969 div 400) + 306 #  days from 0000/03/01 to 1970/01/01
const UNIX_EPOCH_DAY*     = EPOCH_DAY
const YEAR_ONE*  = 365
const YEAR_FOUR* = YEAR_ONE * 4 + 1  #  it is YEAR_ONE*4+1 so the maximum reminder of day / YEAR_FOUR is YEAR_ONE * 4 and it occurs only on 2/29
const YEAR_100*  = YEAR_FOUR * 25 - 1
const YEAR_400*  = YEAR_100 * 4 + 1    #  it is YEAR_100*4+1 so the maximum reminder of day / YEAR_400 is YEAR_100 * 4 and it occurs only on 2/29

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

type Time = object
  ## 時間を表します。
  seconds: int64
  nanoseconds : int32

type Date = object
  nanoseconds*: int32
  second*: int8

  minute*: int8

  hour*: int8

  monthday*: int8
  month*: int8
  year*: int16

func addMilliSec(this : Time, addMsec : uint32 ) : Time =
  ## 現在の時間に指定されたミリ秒を追加します。
  const nanoSecondMax = 999_999_999'u32
  # オーバーフローしないように型を変更
  # ナノ秒単位に変換
  let converted = addMsec * 1000'u64
  let ns = this.nanoseconds.uint64 + converted
  # あふれることが無いので元の型に戻す
  let currentNsec = (ns mod nanoSecondMax).int32

  # 秒数に関してはオーバーフローする可能性があるが、それは現実的ではない大きな値なので無視する
  let currentMsec = this.seconds + (ns div nanoSecondMax).int64

  return Time(seconds : currentMsec, nanoseconds: currentNsec)

proc getDate*(this : Time) : Date =
  ## 引数のUnix時間を西暦表記に変更します。
  ## 参考 http://mrkk.ciao.jp/memorandom/unixtime/unixtime.html

  const monthday = [ 0'u16,31,61,92,122,153,184,214,245,275,306,337 ]

  var unixtime = this.seconds + GMT_TOKYO.int64
  let second = (unixtime mod 60).int8
  let minute = ((unixtime div 60) mod 60).int8
  let hour = ((unixtime div 3600) mod 24).int8

  var unixday = (unixtime div SECONDS_IN_A_DAY).uint32
  let weekday = ((unixday + 3) mod 7).uint8 #  because the unix epoch day is thursday
  #  days from 0000/03/01 to 1970/01/01
  unixday = unixday + UNIX_EPOCH_DAY
  discard Serial.print(unixday, 10'u8)
  Serial.println("")

  var year = 400 * (unixday div YEAR_400)
  unixday = unixday mod YEAR_400

  var n = (unixday div YEAR_100).uint32;
  year += (n * 100).uint16
  unixday = unixday mod YEAR_100

  var leap = false
  if n == 4:
      leap = true
  else:
      year += 4 * (unixday div YEAR_FOUR).uint16
      unixday = unixday mod YEAR_FOUR
      
      n = (unixday div YEAR_ONE).uint16
      year += n.uint16
      unixday = unixday mod YEAR_ONE;
      if n == 4:
          leap = true

  var month : int8
  var day : int8
  if leap :
      month = 2;
      day = 29;
  else :
      let monthIndex = ((unixday * 5 + 2) div 153).int8
      day = (unixday - monthday[monthIndex] + 1).int8
      month = (monthIndex + 3) mod 12
      ## 翌年の1、2、3月の場合
      if month <= 3 :
          year = year + 1
    
  return Date(nanoseconds : this.nanoseconds, second : second, minute : minute, hour : hour, monthday : day, month : month, year : year.int16)

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

