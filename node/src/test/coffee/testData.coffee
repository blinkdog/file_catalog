# testData.coffee
#----------------------------------------------------------------------

Array::random ?= ->
  return null if not @length
  return @[Math.floor Math.random() * @length]

BASE_PATH = "/data"

CATEGORIES = [
  "calibration"
  "cascades"
  "FAT"
  "filtered"
  "generated"
  "GRB"
  "high-energy"
  "hole"
  "internal-system"
  "minbias"
  "monitoring"
  "propagated"
  "TestDAQ"
  "unbiased"
  "unclassified"
  "upmu"
  "verification"
  "webcam"
  "wimp"
]

DAYS = ("00#{i}".substr -2 for i in [1..31])

MONTHS = ("00#{i}".substr -2 for i in [1..12])

SENSOR_NAMES = [
  "AMANDA"
  "AURA"
  "EHWD"
  "IceCube"
  "SPASE-2"
  "ARA"
  "DM-Ice"
  "IC40"
  "IceTop"
  "RICE"
  "SPASE"
]

SOURCE_NAMES = [
  "ana"
  "exp"
  "sim"
]

SUBCATEGORIES = [
  "acoustic"
  "DAQConfigNorth"
  "DebugData"
  "DOMCal"
  "DOMCal-compressed"
  "DOMCal-unvetted"
  "evt"
  "expcont"
  "flasher"
  "hit-spooling"
  "hit-spooling-satellite"
  "I3Live"
  "I3MS"
  "IceACT"
  "Inclinometer"
  "ITS"
  "level2"
  "media"
  "moni"
  "OfflineDB"
  "ofu-testtrigger"
  "ofu-trigger"
  "PFFilt"
  "pole"
  "PoleBaseGCDs"
  "ProcNorth"
  "ProcNorthLive"
  "psl"
  "skycam"
  "sn"
  "sndaq"
  "SouthPole"
  "sps-gcd"
  "tcal"
  "trigger-filter-rates"
  "VEMCal"
]

YEARS = ("#{2000+i}" for i in [4..16])

createFileName = (subcat) ->
  DATA_FIELD = [
    "Astnonomy"
    "Biology"
    "Botany"
    "Chemistry"
    "Geology"
    "Physics"
    "Zoology"
  ]
  DATA_TYPE = [
    "Calibrating"
    "Filtering"
    "Oxidizing"
    "Reducing"
    "Staining"
    "Testing"
  ]
  EXTS = [
    ".iso"
    ".lha"
    ".rar"
    ".sit"
    ".tar.bz2"
    ".tar.gz"
    ".tar.xz"
    ".zip"
  ]
  field = DATA_FIELD.random()
  type = DATA_TYPE.random()
  run = "00000000#{Math.floor Math.random() * 500000}".substr -8
  subrun = "00000000"
  seq = "00000000#{Math.floor Math.random() * 1000}".substr -8
  ext = EXTS.random()
  return "#{subcat}_#{field}#{type}_Run#{run}_Subrun#{subrun}_#{seq}#{ext}"

createFilePath = ->
  source = SOURCE_NAMES.random()
  sensor = SENSOR_NAMES.random()
  year = YEARS.random()
  category = CATEGORIES.random()
  subcategory = SUBCATEGORIES.random()
  mm = MONTHS.random()
  dd = DAYS.random()
  fn = createFileName subcategory
  return "#{BASE_PATH}/#{source}/#{sensor}/#{year}/#{category}/#{subcategory}/#{mm}#{dd}/#{fn}"

createMetadata = ->
  return FILE_METADATA =
    file_name: createFilePath()

exports.createMetadata = createMetadata

#----------------------------------------------------------------------
# end of filesTest.coffee
