Helper = require('hubot-test-helper')
helper = new Helper('../scripts/greetings.coffee')

expect = require('chai').expect

describe 'greetings', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'say one of the random hellos when a user enters a room', ->
    @room.user.enter('').then =>
      expect(@room.messages[0][1]).oneOf @room.robot.brain.get "enterReplies"

  it 'say one of the random goodbyes when a user leaves a room', ->
    @room.user.leave('').then =>
      expect(@room.messages[0][1]).oneOf @room.robot.brain.get "leaveReplies"

  