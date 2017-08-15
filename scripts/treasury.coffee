# Description:
#   routs for making hacbot do things
#
# Notes:
#
#   

room = process.env.TREASURY_GROUP

module.exports = (robot) ->
  
  robot.router.post '/hubot/treasury/ipn', (req, res) ->
    treasury = robot.brain.get('treasury') or { paypal: 0 }
    treasury.paypal = parseFloat(treasury.paypal) + parseFloat(req.body.mc_gross)
    robot.brain.set 'treasury', treasury
    robot.messageRoom room, "#{req.body.first_name} #{req.body.last_name} (#{req.body.payer_email}) sent $#{req.body.mc_gross} to #{req.body.receiver_email}"
    robot.adapter.client.web.groups.setTopic(room, "*Current balances* Paypal: $#{treasury.paypal}")
    res.send 'OK'

  robot.respond /spend \$(.*) from paypal(.*)/i, (res) ->
    if res.message.room == room
      treasury = robot.brain.get('treasury') or { paypal: 0 }
      treasury.paypal = parseFloat(treasury.paypal) - parseFloat(res.match[1])
      robot.brain.set 'treasury', treasury
      robot.adapter.client.web.groups.setTopic(res.message.room, "*Current balances* Paypal: $#{treasury.paypal}")
    else
      res.send 'not autorised in this room'

  # paypal is using ipn for recipts but other accounts could use this
  # robot.respond /recive \$(.*) in paypal(.*)/i, (res) ->
  #   if res.message.room == room
  #     treasury = robot.brain.get('treasury') or { paypal: 0 }
  #     treasury.paypal = parseFloat(treasury.paypal) + parseFloat(res.match[1])
  #     robot.brain.set 'treasury', treasury
  #     robot.adapter.client.web.groups.setTopic(res.message.room, "*Current balances* Paypal: $#{treasury.paypal}")
  #   else
  #     res.send 'not autorised in this room'

  robot.respond /set paypal balance to \$(.*)/i, (res) ->
    if res.message.room == room
      treasury = robot.brain.get('treasury') or { paypal: 0 }
      treasury.paypal = parseFloat(res.match[1])
      robot.brain.set 'treasury', treasury
      robot.adapter.client.web.groups.setTopic(res.message.room, "*Current balances* Paypal: $#{treasury.paypal}")
    else
      res.send 'not autorised in this room'