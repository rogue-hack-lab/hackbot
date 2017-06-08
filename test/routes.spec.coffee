Helper = require('hubot-test-helper')
helper = new Helper('../scripts/routes.coffee')

expect = require('chai').expect

describe 'routes', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it '"hubot announce * " results in hubot announcing to the room'
    # @room.user.say('user', '@hubot announce').then =>
    #   expect(@room.messages).to.include ['hubot', ' announce test']

  it '"hubot say * " results in hubot saying it to the room'
