# Description:
#   routs for making hacbot do things
#
# Notes:
#   

module.exports = (robot) ->
  
  robot.router.post '/hubot/announce/:room', (req, res) ->
    room   = req.params.room
    robot.messageRoom room, "*Announcement:*\n>>> #{req.body.msg}"
    res.send 'OK'
  
  robot.router.post '/hubot/say/:room', (req, res) ->
    room   = req.params.room
    robot.messageRoom room, "#{req.body.msg}"
    res.send 'OK'
  
  robot.router.post '/hubot/emote/:room', (req, res) ->
    channelFromName(req.params.room).then (room) ->
      robot.adapter.client.web.chat.meMessage(room.id, "#{req.body.msg}")
    res.send 'OK'

  robot.router.post '/hubot/react/:room', (req, res) ->
    channelFromName(req.params.room).then (room) ->
      lastMsgInChannel(room.id).then (ts) ->
        robot.adapter.client.web.reactions.add(req.body.emoji, {channel: room.id, timestamp: ts})
    res.send 'OK'

  channelFromName = (roomName) -> 
    robot.adapter.client.web.channels.list({exclude_archived: true, exclude_members: true}).then ( rooms ) ->   
      findRoom = (rooms) ->
        rooms.name == roomName
      rooms.channels.find(findRoom)

  lastMsgInChannel = (channelID) -> 
    robot.adapter.client.web.channels.history(channelID, {count: 1}).then ( history ) ->   
      history.messages[0].ts

