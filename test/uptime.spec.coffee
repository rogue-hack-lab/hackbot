Helper = require('hubot-test-helper')
helper = new Helper('../scripts/uptime.coffee')

expect = require('chai').expect

describe 'uptime', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'seconds', ->
    @room.user.say('kevin', '@hubot uptime').then =>
      expect(@room.messages).to.eql [
        ['kevin', '@hubot uptime']
        ['hubot', 'I\'ve been sentient for ']
      ]
