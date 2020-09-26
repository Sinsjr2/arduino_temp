import arduino
import arduino/Print as p
import wire/wire as w
import sd/SD as s
# import sd/utility/Sd2Card as c
import strutils
import sd/utility/SdFat as sf
import parseutils as pu
import sugar

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
  milliseconds : int32

type Date = object
  milliseconds*: int32
  second*: int8

  minute*: int8

  hour*: int8

  monthday*: int8
  month*: int8
  year*: int16

func addMilliSec(this : Time, addMsec : uint32 ) : Time =
  ## 現在の時間に指定されたミリ秒を追加します。
  const milliSecondMax = 1_000'u64
  # オーバーフローしないように型を変更
  # ナノ秒単位に変換
  let converted = addMsec.uint64
  let ns = this.milliseconds.uint64 + converted
  # あふれることが無いので元の型に戻す
  let currentNsec = (ns mod milliSecondMax).int32

  # 秒数に関してはオーバーフローする可能性があるが、それは現実的ではない大きな値なので無視する
  let currentMsec = this.seconds + (ns div milliSecondMax).int64

  return Time(seconds : currentMsec, milliseconds: currentNsec)

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
    
  return Date(milliseconds : this.milliseconds, second : second, minute : minute, hour : hour, monthday : day, month : month, year : year.int16)

proc readI2CTemplature() : float =
  ## i2c経由で温度センサの値を読み込みます。
  discard w.Wire.requestFrom(0x49'u8, 2'u8)
  var temp = 0'u16;
  while 0'u8 < w.Wire.available():
    let b = Wire.read();
    temp = temp shl 8'u8;
    temp = temp or b;

  return temp.float / 128.0f

## 現在のunixTime
var currentUnixTime : Time


proc printDate(pri : var p.Print, date : Date) =
  discard pri.print(date.year)
  discard pri.print("/")
  discard pri.print(date.month)
  discard pri.print("/")
  discard pri.print(date.monthday)
  discard pri.print(" ")
  discard pri.print(date.hour)
  discard pri.print(":")
  discard pri.print(date.minute)
  discard pri.print(":")
  discard pri.print(date.second)

proc printTemplature() =
  ## センサーから読み込んだ温度を表示します
  var date = currentUnixTime.getDate()
  var temp = readI2CTemplature()

  # if (not s.SDc.begin(4)):
  #   return

  var myFile = s.SDc.open("test.txt", s.FILE_WRITE)
  if (not myFile):
    discard Serial.println("error opening test.txt");
    return
  printDate(myFile, date)
  discard myFile.print(" ")

  discard myFile.print(temp)
  discard myFile.write(('\n').uint8)

  myFile.close()
  # s.SDc.`end`()

type CycleTimer = object
  currentTime : uint32
  waitTime : uint32
  onPassedTime : proc ()

proc onUpdate(this : var CycleTimer, deltaTime: uint32) =
  this.currentTime += deltaTime
  if this.waitTime <= this.currentTime:
    # 設定した時間が多すぎた場合に複数回呼び出さないようにするため
    this.currentTime = this.currentTime mod this.waitTime
    this.onPassedTime()

func cycleTimerMS(milliSec: uint32, onPassedTime : proc (), callsFirst : bool) : CycleTimer =
  ## 指定されたミリ秒ごとに関数を呼び出します。
  ## 戻り値のオブジェクトを一定期間毎に呼び出す必要があります。
  ## 初回の呼び出しでコールバック関数を呼び出すかどうかを指定します。
  if callsFirst :
    onPassedTime()
  return CycleTimer(currentTime : 0, waitTime : milliSec, onPassedTime : onPassedTime)

type TimeDelta = object
  ## 前回との時間の差分を計算するためのクラスです。
  prevTimeMsec : uint32
  deltaTime : uint32


func calcDeltaTimeMs(this : TimeDelta, passedTime : uint32) : TimeDelta =
  ## 前回との時間の差分(ミリ秒)を計算します。

  # オーバーフローやアンダーフローすることを前提としている
  {.push overflowChecks: off}
  let diffTimeMsec = passedTime - this.prevTimeMsec
  {. pop .}
  return TimeDelta(prevTimeMsec : passedTime, deltaTime : diffTimeMsec)

## 温度の観測周期時間(ミリ秒)
const observeTempTimeMS = 10 * 60 * 1000

## 温度を観測し、その温度をSDカードに保存するのに使用するタイマー
var sensorSdTimer : CycleTimer

## 現在時刻を保存するファイル名
const timeFilename = "/cutime.txt"

## sdカードのファイルの現在時刻の更新周期時間
const currentTimeUpdateMsec = 2 * 60 * 1000

## SDカードのファイルの現在時刻を書き換えるためのタイマー
var sdFileCurrentTimeUpdateTimer : CycleTimer

proc setupCurrentTime() : Time =
  ## 現在の時刻をセットアップします。
  ## SDカードのファイルの中に現在の時刻が書かれていればそちらを返し、そうでなければ
  ## ハードコードの時間を返します。
  ## ファイルの中にはunixtime(秒)が整数で入っています。
  const defaultTime = Time(seconds: 1560000000'i64, milliseconds: 0)
  # if (not s.SDc.begin(4)):
  #   return defaultTime

  var configFile = s.SDc.open(timeFilename, sf.O_READ)
  discard Serial.println(if s.SDc.exists(timeFilename) :
                   "true"
                 else :
                   "false")

  if not configFile:
    configFile.close()

    return defaultTime

  var timeStr = ""
  while 0 < configFile.available():
    timeStr.add(configFile.read().char)
  configFile.close()

  var seconds: BiggestInt
  let len = pu.parseBiggestInt(timeStr, seconds, 0)
  if len == 0 or len != timeStr.len:
    return defaultTime

  return Time(seconds: seconds, milliseconds : 0)

proc updateCurrentTimeInFile(currentTime : Time) =
  ## SDカードのファイル内に記述されている現在時刻を更新します。
  ## SDカードが無い場合は何もしません。
  ## また、ファイルがなければ新しく作ります。

  var configFile = s.SDc.open(timeFilename, sf.O_WRITE or sf.O_CREAT or sf.O_TRUNC)
  discard Serial.print("update time in sd ")
  printDate(Serial, currentUnixTime.getDate())
  discard Serial.println()

  discard Serial.println(if s.SDc.exists(timeFilename) :
                   "true"
                 else :
                   "false")
  if not configFile:
    return

  discard configFile.print($currentTime.seconds)
  configFile.close()



setup:
  Serial.begin 9600
  discard Serial.println "<Arduino is ready>"
  w.Wire.begin()
  if (not s.SDc.begin(4)):
    discard Serial.println("SD initialize failed")

  currentUnixTime = setupCurrentTime()
  printDate(Serial, currentUnixTime.getDate())
  discard Serial.println()


  # var myFile = s.SDc.open("test.txt", s.FILE_READ)
  # if (not myFile):
  #   discard Serial.println("error opening test.txt");
  #   return

  # discard Serial.println(myFile.available().intToStr())
  # while (myFile.available() != 0):
  #   discard Serial.write(myFile.read().uint8);
  # myFile.close()
  sdFileCurrentTimeUpdateTimer = cycleTimerMS(currentTimeUpdateMsec, () => updateCurrentTimeInFile(currentUnixTime), true)
  sensorSdTimer = cycleTimerMS(observeTempTimeMS, () => printTemplature(), true)

proc printStr(str : string) =
  for c in str:
    discard Serial.write(cast[uint8](c))

## loop関数で呼ばれてから経過した時間
var prevTimeMsec = TimeDelta()


loop:
  # 前回との時間の差分をとる
  prevTimeMsec = prevTimeMsec.calcDeltaTimeMs(millis().uint32)
  currentUnixTime = currentUnixTime.addMilliSec(prevTimeMsec.deltaTime)
  sdFileCurrentTimeUpdateTimer.onUpdate(prevTimeMsec.deltaTime)
  sensorSdTimer.onUpdate(prevTimeMsec.deltaTime)

