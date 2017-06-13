process.env.HUBOT_AUTH_ADMIN = 1
Helper = require('hubot-test-helper')
helper = new Helper('../node_modules/hubot-auth/index.coffee')

expect = require('chai').expect

describe 'test-tester scripts - for testing how to setup tests', ->
	beforeEach ->
		@room = helper.createRoom()
		@testuser = @room.robot.brain.userForId 'testuser',
			name: 'testuser'
			id: process.env.HUBOT_AUTH_ADMIN  

	afterEach ->
		@room.destroy()
	
	context '', ->
		beforeEach ->
			helper.constructor('../node_modules/hubot-auth/index.coffee')
			
		it 'loads hubot-auth for testing',->
			auth = @room.robot.auth
			@room.user.say('testuser','hubot what roles do I have')
				.then => @room.user.say('testuser','hubot testuser has brain-surgeon role')
					.then => console.log @room.messages
			#@room.robot.auth.hasRole(@testUser, 'brain-surgeon')
			
		
		# expect(@room.robot.auth).not.to.be.undefined

#   it 'Set PING role for user', ->
#     # @room.user.say('Patrick', 'ping').then =>
#     #   expect(@room.messages).to.eql [
#     #     ['Patrick','ping']
#     #     ['hubot','pong']]
