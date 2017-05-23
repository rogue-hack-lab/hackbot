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
  WFKeys = robot.brain.get('wf-keys') or []
  oldWFAmount = parseInt(robot.brain.get('wf-' + subject)) or 0
  newWFAmount = oldWFAmount + WFAmount
  WFText = 'not changed'
  if Math.abs(newWFAmount) == 1
    WFPlural = 'Warm Fuzzy'
  else
    WFPlural = 'Warm Fuzzies'
    
  robot.brain.set 'wf-' + subject, newWFAmount
  if WFKeys.indexOf('wf-' + subject) < 0
    WFKeys.push 'wf-' + subject
    robot.brain.set 'wf-keys', WFKeys
  if oldWFAmount < newWFAmount
    WFText = 'increased to {amount}'.replace('{amount}', newWFAmount.toString())
  else if oldWFAmount > newWFAmount
    WFText = 'decreased to {amount}'.replace('{amount}', newWFAmount.toString())
  res.send '{subject}\'s has {WFText} {WFPlural}.'
    .replace('{subject}', subject)
    .replace('{WFText}', WFText)
    .replace('{WFPlural}', WFPlural)
  return

module.exports = (robot) ->
  robot.respond /(Warm\s?Fuzz(y|ies|)|wf) list/i, (res) ->
    WFKeys = robot.brain.get('wf-keys')
    messages = WFKeys.map((key) ->
      val = robot.brain.get(key)
      '{key} = {value}'.replace('{key}', key.replace('wf-','')).replace '{value}', val
    )
    res.send messages.join('\n')
    return
  robot.hear /\s*(@\w+)\s?[+]{2}[+]*/i, (res) ->
    plusCount = (res.message.text.match(/[+]/g) or []).length
    positiveWFAmount = if plusCount > 2 then plusCount - 1 else 1
    sendWFMessage robot, res, positiveWFAmount
    return
  robot.hear /\s*(@\w+)\s?[-]{2}[-]*/i, (res) ->
    minusCount = (res.message.text.match(/[-]/g) or []).length
    negativeWFAmount = -(if minusCount > 2 then minusCount - 1 else 1)
    sendWFMessage robot, res, negativeWFAmount
    return
  return