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

  context '@notaSurgeon is not a brain-surgeon and attempts to view the robot brain', ->
    beforeEach ->
      @room.user.say('@notasurgeon', '@hubot brain')
    it "tells @notaSurgeon that they are not allowed to access robot's brain"

  context '@aSurgeon is a brain-surgeon and attempts to view the robot brain', ->
    it 'checks that @aSurgeon has the role "brain-surgeon"'
      # @room.user.say('user', '@hubot brain get').then =>
      #   delay 1000, ->
      #     expect(@room.messages).to.deep.include ['hubot','@user: Access Denied. You need role `brain-surgeon` to perform this action.']