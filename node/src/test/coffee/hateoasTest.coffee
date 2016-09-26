# hateoasTest.coffee
#----------------------------------------------------------------------

PATH_TO_CONFIG_FILE = "./config.cson"

CSON = require "cson"
request = require "supertest"
should = require "should"

config = CSON.load PATH_TO_CONFIG_FILE

app =
  address: ->
    server =
      port: config.port
  listen: ->

HATEOAS =
  files: { href: "#{config.baseUri}/files" }
  _links: { self: { href: "#{config.baseUri}" } }

describe "HATEOAS", ->
  it "DELETE #{config.baseUri} should return an error", (done) ->
    request(app)
    .delete config.baseUri
    .expect "Content-Type", /json/
    .expect (res) ->
      res.body.should.be.empty()
    .expect 405, done
    return true

  it "GET #{config.baseUri} should return some links", (done) ->
    request(app)
    .get config.baseUri
    .expect "Content-Type", /json/
    .expect (res) ->
      res.body.should.eql HATEOAS
    .expect 200, done
    return true

  it "POST #{config.baseUri} should return an error", (done) ->
    request(app)
    .post config.baseUri
    .expect "Content-Type", /json/
    .expect (res) ->
      res.body.should.be.empty()
    .expect 405, done
    return true

  it "PUT #{config.baseUri} should return an error", (done) ->
    request(app)
    .put config.baseUri
    .expect "Content-Type", /json/
    .expect (res) ->
      res.body.should.be.empty()
    .expect 405, done
    return true

#----------------------------------------------------------------------
# end of configTest.coffee
