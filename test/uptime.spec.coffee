Helper = require('hubot-test-helper')
helper = new Helper('../scripts/uptime.coffee')

expect = require('chai').expect

describe 'uptime.coffee', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()
  
  context '@user asks hubot for uptime', ->
    beforeEach ->
      @room.user.say('user', '@hubot uptime')
    it 'hubot responds with how long it has been up', ->
        expect(@room.messages).to.deep.include ['hubot', 'I\'ve been sentient for ']
