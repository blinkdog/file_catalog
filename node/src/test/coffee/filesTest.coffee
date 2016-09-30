# filesTest.coffee
#----------------------------------------------------------------------

_ = require "underscore"
$ = null

require("jsdom").env "", (err, win) ->
  throw err if err?
  $ = require("jquery")(win)

PATH_TO_CONFIG_FILE = "./config.cson"

CSON = require "cson"
request = require "supertest"
should = require "should"
UUID = require "uuid"

testData = require "./testData"

config = CSON.load PATH_TO_CONFIG_FILE

app =
  address: ->
    server =
      port: config.port
  listen: ->

INVALID_QUERY_PARAMETERS = (res) ->
  res.body.should.have.property "message"
  res.body.message.should.equal "invalid query parameters"

NO_REST_KEYS = (value, key, object) ->
  return key[0] isnt "_"

NOT_FOUND = (res) ->
  res.body.should.have.property "message"
  res.body.message.should.equal "not found"

describe "#{config.baseUri}/files", ->
  it "DELETE #{config.baseUri}/files should return an error", (done) ->
    request(app)
    .delete "#{config.baseUri}/files"
    .expect "Content-Type", /json/
    .expect (res) ->
      res.body.should.be.empty()
    .expect 405, done
    return true

  it "GET #{config.baseUri}/files?start=-1 should return an error", (done) ->
    request(app)
    .get "#{config.baseUri}/files?start=-1"
    .expect "Content-Type", /json/
    .expect INVALID_QUERY_PARAMETERS
    .expect 400, done
    return true

  it "GET #{config.baseUri}/files?limit=0 should return an error", (done) ->
    request(app)
    .get "#{config.baseUri}/files?limit=0"
    .expect "Content-Type", /json/
    .expect INVALID_QUERY_PARAMETERS
    .expect 400, done
    return true

  it "GET #{config.baseUri}/files should return multiple files", (done) ->
    request(app)
    .get "#{config.baseUri}/files"
    .expect "Content-Type", /json/
    .expect (res) ->
      res.should.be.ok()
      res.should.have.property "body"
      {body} = res
      body.should.be.ok()
      body.should.have.property "files"
      {files} = body
      files.should.be.ok()
      files.should.not.be.empty()
    .expect 200, done
    return true

  it "PATCH #{config.baseUri}/files should return an error", (done) ->
    request(app)
    .patch "#{config.baseUri}/files"
    .expect "Content-Type", /json/
    .expect (res) ->
      res.body.should.be.empty()
    .expect 405, done
    return true

  it "POST #{config.baseUri}/files should return a link", (done) ->
    FILE_METADATA = testData.createMetadata()
    FILE_METADATA_JSON = JSON.stringify FILE_METADATA, null, 2
    request(app)
    .post "#{config.baseUri}/files"
    .type "json"
    .send FILE_METADATA_JSON
    .expect "Content-Type", /json/
    .expect (res) ->
      res.body.should.be.ok()
      res.body.should.have.property "file"
      res.body.file.should.startWith "#{config.baseUri}/files/"
    .expect 201, done
    return true

  it "PUT #{config.baseUri}/files should return an error", (done) ->
    request(app)
    .put "#{config.baseUri}/files"
    .expect "Content-Type", /json/
    .expect (res) ->
      res.body.should.be.empty()
    .expect 405, done
    return true

  xdescribe "out-of-spec behavior", ->
    it "GET #{config.baseUri}/files?ignoreMe=true should not return an error", (done) ->
      request(app)
      .get "#{config.baseUri}/files?ignoreMe=true"
      .expect "Content-Type", /json/
      .expect (res) ->
        res.body.should.be.ok()
        res.body.should.not.be.empty()
      .expect 200, done
      return true

    it "GET #{config.baseUri}/files?query=0 should return no files", (done) ->
      request(app)
      .get "#{config.baseUri}/files?query=0"
      .expect "Content-Type", /json/
      .expect (res) ->
        res.body.should.be.ok()
        res.body.should.be.empty()
      .expect 200, done
      return true

    it "GET #{config.baseUri}/files?[query] should return a file", (done) ->
      $.should.be.ok()
      FILE_METADATA = testData.createMetadata()
      FILE_METADATA_JSON = JSON.stringify FILE_METADATA, null, 2
      query = $.param FILE_METADATA
      console.log "query: #{query}"
      request(app)
      .get "#{config.baseUri}/files?query%3Dfile_name%3D%2Fdata%2Fana%2FEHWD%2F2016%2Fverification%2Fexpcont%2F0822%2Fexpcont_PhysicsFiltering_Run00330915_Subrun00000000_00000684.rar"
      .expect "Content-Type", /json/
      .expect (res) ->
        console.log "res.body: ", res.body
        res.body.should.be.ok()
        res.body.should.not.be.empty()
        res.body.files.should.not.be.empty()
      .expect 200, done
      return true

describe "#{config.baseUri}/files/{file_id}", ->
  it "GET #{config.baseUri}/files/{file_id} should return 404", (done) ->
    file_id = "57ee9e59c9f03311a99e6b77"
    request(app)
    .get "#{config.baseUri}/files/#{file_id}"
    .expect "Content-Type", /json/
    .expect NOT_FOUND
    .expect 404, done
    return true

  it "GET #{config.baseUri}/files/{file_id} should return the metadata", ->
    FILE_METADATA = testData.createMetadata()
    FILE_METADATA_JSON = JSON.stringify FILE_METADATA, null, 2
    return new Promise (resolve, reject) ->
      _fileUri = null
      request(app)
      .post "#{config.baseUri}/files"
      .type "json"
      .send FILE_METADATA_JSON
      .expect "Content-Type", /json/
      .expect (res) ->
        res.body.should.be.ok()
        res.body.should.have.property "file"
        res.body.file.should.startWith "#{config.baseUri}/files/"
        _fileUri = res.body.file
      .expect 201, (err) ->
        return reject err if err?
        resolve _fileUri
    .then (fileUri) ->
      return new Promise (resolve, reject) ->
        _body = null
        request(app)
        .get fileUri
        .expect "Content-Type", /json/
        .expect (res) ->
          res.body.should.be.ok()
          filtered = _.pick res.body, NO_REST_KEYS
          filtered.should.eql FILE_METADATA
          _body = res.body
        .expect 200, (err) ->
          return reject err if err?
          resolve _body

describe "#{config.baseUri}/files/{uuid}", ->
  xdescribe "out-of-spec behavior", ->
    it "GET #{config.baseUri}/files/{uuid} should return 404", (done) ->
      uuid = UUID.v4()
      request(app)
      .get "#{config.baseUri}/files/#{uuid}"
      .expect "Content-Type", /json/
      .expect (res) ->
        res.body.should.be.empty()
      .expect 404, done
      return true


#----------------------------------------------------------------------
# end of filesTest.coffee
