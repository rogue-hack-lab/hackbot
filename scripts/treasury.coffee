# Description:
#   keep track of $$ from paypal
#
# Notes:
#   https://developer.paypal.com/docs/classic/ipn/integration-guide/IPNandPDTVariables/
#   test with `curl -X POST --data "data" http://rhl:password@localhost:8080/hubot/treasury/ipn


room = process.env.TREASURY_GROUP

module.exports = (robot) ->
  
  robot.router.post '/hubot/treasury/ipn', (req, res) ->
    switch req.body.txn_type
      when 'subscr_signup'
        robot.messageRoom room, "#{req.body.first_name} #{req.body.last_name} (#{req.body.payer_email}) signed up for a $#{req.body.option_selection1} membership"
      when 'send_money'
        robot.messageRoom room, "#{req.body.first_name} #{req.body.last_name} (#{req.body.payer_email}) just sent a onetime payment of $#{req.body.mc_gross}"
        updateBalance robot,req
      when 'subscr_payment'
        robot.messageRoom room, "#{req.body.first_name} #{req.body.last_name} (#{req.body.payer_email}) just sent $#{req.body.mc_gross} for their recuring subscription"
        updateBalance robot,req
      else robot.messageRoom room, "Excuse me.. I dont know how to deal with the IPN type of #{req.body.txn_type}"
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

updateBalance = (robot, req) ->
  treasury = robot.brain.get('treasury') or { paypal: 0 }
  treasury.paypal = parseFloat(treasury.paypal) + parseFloat(req.body.mc_gross) - parseFloat(req.body.mc_fee)
  robot.brain.set 'treasury', treasury
  robot.adapter.client.web.groups.setTopic(room, "*Current balances* Paypal: $#{treasury.paypal}")
