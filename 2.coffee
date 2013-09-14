# here is an example node server that we will trace

http = require 'http'
fs = require 'fs'
_ = require 'lodash'
PORT = 1337

srv = http.createServer (req, res) ->
  if req.url is '/'
    gif = _.sample(file for file in fs.readdirSync __dirname when file.match /\.gif$/)
    console.log "Serving a #{gif.substr(0, gif.length - 4)}"
    res.writeHead 200, 'Content-Type': 'image/gif'
    fs.createReadStream(gif).pipe res

srv.listen PORT, ->
  console.log "Server running at http://localhost:#{PORT}"
