# Description:
#   A simple hubot that keeps track of WF. (http://www.claudesteiner.com/fuzzy.htm)
#
# Commands:
#   hubot WF list
#   @[subject]++
#
# Author:
#   Adapted from HerrPfister hubot-karmabot

sendWFMessage = (robot, res, WFAmount) ->
  subject = res.match[1] or res.match[2]
  if subject is "@#{res.message.user.name}"
    if WFAmount > 0
      res.send 'Warm fuzzies are meant to be given to others.'
    else
      res.send "Aww, don't be so hard on yourself."
  else
    warmFuzzy = robot.brain.get('warmFuzzy') or {}
    oldWFAmount = parseInt(warmFuzzy[subject]) or 0
    newWFAmount = oldWFAmount + WFAmount
    WFText = 'not changed'
    if Math.abs(newWFAmount) == 1
      WFPlural = 'Warm Fuzzy'
    else
      WFPlural = 'Warm Fuzzies'
    warmFuzzy[subject] = newWFAmount
    robot.brain.set 'warmFuzzy', warmFuzzy
    if oldWFAmount < newWFAmount
      WFText = 'increased to {amount}'.replace('{amount}', newWFAmount.toString())
    else if oldWFAmount > newWFAmount
      WFText = 'decreased to {amount}'.replace('{amount}', newWFAmount.toString())
    res.send "#{subject}\'s has #{WFText} #{WFPlural}."

module.exports = (robot) ->
  robot.respond /(Warm\s?Fuzz(y|ies|)|wf) list/i, (res) ->
    warmFuzzy = robot.brain.get('warmFuzzy')
    messages = ""
    for user,wf of warmFuzzy
      messages += "#{user} = #{wf}\n"
    res.send messages

  robot.hear /\s*(@\w+)\s?[+]{2}[+]*/i, (res) ->
    plusCount = (res.message.text.match(/[+]/g) or []).length
    positiveWFAmount = if plusCount > 2 then plusCount - 1 else 1
    sendWFMessage robot, res, positiveWFAmount

  robot.hear /\s*(@\w+)\s?[-]{2}[-]*/i, (res) ->
    minusCount = (res.message.text.match(/[-]/g) or []).length
    negativeWFAmount = -(if minusCount > 2 then minusCount - 1 else 1)
    sendWFMessage robot, res, negativeWFAmount
