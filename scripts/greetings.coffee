module.exports = (robot) ->
  enterReplies = require('../stubs/enterReplies')
  leaveReplies = require('../stubs/leaveReplies')  
  robot.enter (res) ->
    res.send res.random enterReplies
    
  robot.leave (res) ->
    res.send res.random leaveReplies
# @here, Please join me in welcoming @user to the Rogue Hack Lab!!! :tada: