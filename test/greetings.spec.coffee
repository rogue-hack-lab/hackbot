Helper = require('hubot-test-helper')
helper = new Helper('../scripts/greetings.coffee')

expect = require('chai').expect

describe 'greetings.coffee', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  context 'a user enters a room',->
    beforeEach ->
      @room.user.enter('')
    it 'say one of the random hellos', ->
        expect(@room.messages[0][1]).oneOf @room.robot.brain.get "enterReplies"
  
  context 'a user exits a room',->
    beforeEach ->
      @room.user.leave('')
    it 'say one of the random goodbyes', ->
      expect(@room.messages[0][1]).oneOf @room.robot.brain.get "leaveReplies"

  