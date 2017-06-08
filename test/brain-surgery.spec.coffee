Helper = require('hubot-test-helper')
helper = new Helper([
    '../scripts/brain-surgery.coffee',
    '../node_modules/hubot-auth/index.coffee'])
process.env.HUBOT_AUTH_ADMIN = '1'

expect = require('chai').expect

describe 'brain-surgery.coffee', ->
  beforeEach ->
    @room = helper.createRoom()
    @room.robot.brain.userForName "testuser",
      name: "testuser"
      id: 1    
    # helper.constructor auth
    

  afterEach ->
    @room.destroy()
  
  it 'requires that a user has brain-surgeon role to operate on hubot'
    # @room.user.say('user', '@hubot brain get').then =>
    #   delay 1000, ->
    #     expect(@room.messages).to.deep.include ['hubot','@user: Access Denied. You need role `brain-surgeon` to perform this action.']