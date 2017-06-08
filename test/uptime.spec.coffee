Helper = require('hubot-test-helper')
helper = new Helper('../scripts/uptime.coffee')

expect = require('chai').expect

describe 'uptime', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'asking hubot for uptime results in a response', ->
    @room.user.say('user', '@hubot uptime').then =>
      expect(@room.messages).to.deep.include ['hubot', 'I\'ve been sentient for ']
