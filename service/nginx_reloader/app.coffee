fs = require('fs')
async = require('async')
request = require('request')

Debug = require('debug')
Debug.enable('nginx-reloader:*')
debug = Debug("nginx-reloader:app")

# AND nginx.conf.erb
NGINX_PID_FILE = '/var/run/nginx.pid'
# http://wiki.nginx.org/CommandLine#Stopping_or_Restarting_Nginx
NGINX_RESTART_SIGNAL = 'SIGHUP'

parseNginxRtmpXML = require('./lib/parseNginxRtmpXML')

RTMP_REPLICATOR = 'localhost'

MINUTES = 60000 #milliseconds
TIME_BETWEEN_CHECKS = 10 * MINUTES

getRTMPServerStats = (server, callback)->
  request.get "http://#{server}/stat", (err, response, body)->
    return callback(err) if err
    return callback(body) if response.statusCode != 200

    parseNginxRtmpXML body, (err, stats)->
      return callback(err) if err
      callback(null, stats)

reschedule = ->
  setTimeout getAllStats, TIME_BETWEEN_CHECKS

getNginxPid = ->
  parseInt fs.readFileSync(NGINX_PID_FILE)

restartServer = ->
  nginxPid = getNginxPid()
  debug('restarting nginx', nginxPid)
  process.kill(nginxPid, NGINX_RESTART_SIGNAL)

getAllStats = ->
  debug('fetching stats')
  getRTMPServerStats RTMP_REPLICATOR, (err, response)->
    return logError(err) if err
    if response.input.total == 0
      restartServer()
    else
      debug("not restarting server current streams:", response.input.total)
    reschedule()

getAllStats()
