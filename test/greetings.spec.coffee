Helper = require('hubot-test-helper')
helper = new Helper('../scripts/greetings.coffee')

enterReplies = require('../stubs/enterReplies')
leaveReplies = require('../stubs/leaveReplies')

expect = require('chai').expect

describe 'hellogoodbye', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'hackbot should say one of the random hellos', ->
    @room.user.enter('').then =>
      expect(@room.messages[0][1]).oneOf enterReplies

  it 'hackbot should say one of the random goodbyes', ->
    @room.user.leave('').then =>
      expect(@room.messages[0][1]).oneOf leaveReplies

  