# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot where are you running
#
# Author:
#   whitman

os = require('os')
moment = require('moment')

module.exports = (robot) ->

  start = new Date().getTime()

  robot.respond /where are you running/i, (msg) ->
    now = new Date().getTime()
    msg.reply os.userInfo().username + ' has been running me for ' + moment.duration(now-start).humanize() + ' on ' + os.hostname()
