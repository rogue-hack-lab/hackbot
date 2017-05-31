Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../scripts/uptime.coffee')

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