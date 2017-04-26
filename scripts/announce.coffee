# Description:
#   Testing for docker deployment
#
# Notes:
#   

module.exports = (robot) ->
  
  robot.router.post '/hubot/announce/:room', (req, res) ->
    room   = req.params.room
    data   = JSON.parse(req.body.payload)
    secret = data.secret
  
    robot.messageRoom room, "I have an announcement: #{secret}"
  
    res.send 'OK'
