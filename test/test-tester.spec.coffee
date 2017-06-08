process.env.HUBOT_AUTH_ADMIN = 1
Helper = require('hubot-test-helper')
helper = new Helper('../node_modules/hubot-auth/index.coffee')

expect = require('chai').expect

describe 'test-tester scripts - for testing how to setup tests', ->
	beforeEach ->
		@room = helper.createRoom()
		@room.robot.brain.userForName 'testuser',
			name: 'testuser'
			id: 1    
		console.log @room.robot.brain.data.users	
	afterEach ->
		@room.destroy()
	context '', ->
		beforeEach ->
			helper.constructor('../node_modules/hubot-auth/index.coffee')
			
		it 'loads hubot-auth for testing',->
			#@room.robot.auth.hasRole(@testUser, 'brain-surgeon')
			# @auth = @room.robot.auth
			console.log(@testuser)
			
		
		# expect(@room.robot.auth).not.to.be.undefined

#   it 'Set PING role for user', ->
#     # @room.user.say('Patrick', 'ping').then =>
#     #   expect(@room.messages).to.eql [
#     #     ['Patrick','ping']
#     #     ['hubot','pong']]
