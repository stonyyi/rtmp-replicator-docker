request = require('request')
cproc = require('child_process')

parseNginxRtmpXML = require('./lib/parseNginxRtmpXML')

RTMP_REPLICATOR = 'localhost'

getRTMPServerStats = (server, callback)->
  request.get "http://#{server}/stat", (err, response, body)->
    return callback(err) if err
    return callback(body) if response.statusCode != 200

    parseNginxRtmpXML body, (err, stats)->
      return callback(err) if err
      callback(null, stats)

exitWithCode = (code)->
  process.exit code

checkForRestart = ->
  console.log 'fetching stats'
  getRTMPServerStats RTMP_REPLICATOR, (err, response)->
    if err
      console.log "couldn't get stats, exiting with code 2"
      exitWithCode(2)
    if response.input.total == 0
      console.log "we should restart nginx (no current streams), exiting with code 1"
      exitWithCode(1)
    else
      console.log "we should not restart nginx (#{response.input.total} current streams), exiting with code 0"
      exitWithCode(0)

if !module.parent
  checkForRestart()
