# configTest.coffee
#----------------------------------------------------------------------

PATH_TO_CONFIG_FILE = "./config.cson"

CSON = require "cson"
should = require "should"

config = CSON.load PATH_TO_CONFIG_FILE

CONFIG_PROPERTIES = [
   "baseUri"
   "host"
   "port"
]

describe "config", ->
  it "will obey the laws of logic", ->
    false.should.equal false
    true.should.equal true

  it "has all the configuration parameters that we expect", ->
    config.should.have.properties CONFIG_PROPERTIES

  it "has only the configuration parameters that we expect", ->
    for key of config
      if not (key in CONFIG_PROPERTIES)
        key.should.equal null

#----------------------------------------------------------------------
# end of configTest.coffee
