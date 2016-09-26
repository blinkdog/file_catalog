# filesTest.coffee
#----------------------------------------------------------------------

PATH_TO_CONFIG_FILE = "./config.cson"

CSON = require "cson"
request = require "supertest"
should = require "should"
UUID = require "uuid"

config = CSON.load PATH_TO_CONFIG_FILE

app =
  address: ->
    server =
      port: config.port
  listen: ->

describe "#{config.baseUri}/files", ->
  it "DELETE #{config.baseUri}/files should return an error", (done) ->
    request(app)
    .delete "#{config.baseUri}/files"
    .expect "Content-Type", /json/
    .expect (res) ->
      res.body.should.be.empty()
    .expect 405, done
    return true

  it "GET #{config.baseUri}/files should return no files", (done) ->
    request(app)
    .get "#{config.baseUri}/files"
    .expect "Content-Type", /json/
    .expect (res) ->
      res.body.should.not.be.empty()
      res.body.files.should.be.empty()
    .expect 200, done
    return true

  it "GET #{config.baseUri}/files for a UUID should return no files", (done) ->
    uuid = UUID.v4()
    request(app)
    .get "#{config.baseUri}/files/#{uuid}"
    .expect "Content-Type", /json/
    .expect (res) ->
      res.body.should.be.empty()
    .expect 200, done
    return true

  it "PUT #{config.baseUri}/files should return an error", (done) ->
    request(app)
    .put "#{config.baseUri}/files"
    .expect "Content-Type", /json/
    .expect (res) ->
      res.body.should.be.empty()
    .expect 405, done
    return true

#----------------------------------------------------------------------
# end of filesTest.coffee
