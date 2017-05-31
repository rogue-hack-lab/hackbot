Helper = require('../node_modules/hubot-test-helper')
helper = new Helper('./scripts/uptime.coffee')

describe 'uptime', ->
  describe 'characterization tests', ->
  	beforeEach ->
	  	@room = helper.createRoom()
	afterEach ->
		@room.destroy()
	test 'seconds', ->
		@room.user.say('kevin', '@hubot uptime')
			.then ->
				expect(@room.messages).toContain(['hubot', '0 seconds'])
##TODO##
#testDouble date override
#jest snapshots