# Description:
#   Greets users when they enter a room. Says goodbye when they leave.
#
# Commands:
#   Enter or exit a room and hubot will say something.
#

module.exports = (robot) ->
  enterReplies = 
    ['Hi', 'Target Acquired', 'Hello friend.', 'Gotcha', 'I see you', 'Welcome']
  leaveReplies = 
    ['Are you still there?', 'Target lost', 'Searching', 'Hasta Luego']
  
  robot.brain.set "enterReplies", enterReplies
  robot.brain.set "leaveReplies", leaveReplies

  robot.enter (res) ->
    res.send res.random robot.brain.get "enterReplies"
    
  robot.leave (res) ->
    res.send res.random robot.brain.get "leaveReplies"

  #TODO @here, Please join me in welcoming @user to the Rogue Hack Lab!!! :tada: