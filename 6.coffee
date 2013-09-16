# adding custom dtrace bindings to the server

http = require 'http'
fs = require 'fs'
_ = require 'lodash'
dtrace = require 'dtrace-provider'
PORT = 1337

dtp = dtrace.createDTraceProvider 'gifserver'
dtp.addProbe 'respond-gif', 'char *'
dtp.enable()

srv = http.createServer (req, res) ->
  if req.url is '/'
    gif = _.sample(file for file in fs.readdirSync __dirname when file.match /\.gif$/)
    console.log "Serving a #{gif.substr(0, gif.length - 4)}"
    res.writeHead 200, 'Content-Type': 'image/gif'
    fs.createReadStream(gif).pipe res
    dtp.fire 'respond-gif', (p) ->
      [gif]

srv.listen PORT, ->
  console.log "Server running at http://localhost:#{PORT}"
