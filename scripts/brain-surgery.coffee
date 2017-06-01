# Description:
#   This lets you mess with hubot's brain
#
# Commands:
#   hubot brain (get|set) {param} {value}
#   hubot brain users

module.exports = (robot) ->
  robot.respond /brain users$/i, (msg) ->
    unless robot.auth.hasRole(robot.brain.userForName(msg.message.user.name), 'brain-surgeon')
      msg.reply "Access Denied. You need role `brain-surgeon` to perform this action."
      return
    robot.adapter.client.web.files.upload 'Users', { filetype: 'javascript', channels: msg.envelope.room, content: JSON.stringify(robot.brain.data.users, null, 2) }, (err, res) ->
      if err
        msg.reply 'Error:', err
  
  robot.respond /brain get$/i, (msg) ->
    unless robot.auth.hasRole(robot.brain.userForName(msg.message.user.name), 'brain-surgeon')
      msg.reply "Access Denied. You need role `brain-surgeon` to perform this action."
      return
    robot.adapter.client.web.files.upload 'Brain', { filetype: 'javascript', channels: msg.envelope.room, content: JSON.stringify(robot.brain.data['_private'], null, 2) }, (err, res) ->
      if err
        msg.reply 'Error:', err

  robot.respond /brain get\s*(\S+)+/i, (msg) ->
    unless robot.auth.hasRole(robot.brain.userForName(msg.message.user.name), 'brain-surgeon')
      msg.reply "Access Denied. You need role `brain-surgeon` to perform this action."
      return
    key = msg.match[1]
    robot.adapter.client.web.files.upload "Brain for #{key}", { filetype: 'javascript', channels: msg.envelope.room, content: JSON.stringify(robot.brain.get(key), null, 2) }, (err, res) ->
      if err
        msg.reply 'Error:', err    

  robot.respond /brain set (\S+) `{1,3}([\s\S]*?)`{1,3}$/i, (msg) ->
    unless robot.auth.hasRole(robot.brain.userForName(msg.message.user.name), 'brain-surgeon')
      msg.reply "Access Denied. You need role `brain-surgeon` to perform this action."
      return
    key = msg.match[1]
    backup = robot.brain.get(key)
    input = msg.match[2]
    try
      value = JSON.parse(input)
      robot.brain.set(key, value)
      msg.send "Done, previous brain was #{JSON.stringify backup}"
    catch e
      msg.send "Error, #{e}"

  robot.respond /brain remove (\S+)$/i, (msg) ->
    unless robot.auth.hasRole(robot.brain.userForName(msg.message.user.name), 'brain-surgeon')
      msg.reply "Access Denied. You need role `brain-surgeon` to perform this action."
      return
    key = msg.match[1]
    backup = robot.brain.get key
    robot.brain.remove key
    msg.send "Done, previous brain was #{JSON.stringify backup}"