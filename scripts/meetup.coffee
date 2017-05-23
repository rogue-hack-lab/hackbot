# Description:
#   Checks every hour for new meetups. Posts in the releveant channel (if it exists) and #events
#
# Dependencies:
#   None
#
# Configuration:
#   None
moment = require('moment-timezone')
moment.locale 'en-use'

generateAnnouncement = (meetup) ->
	eventTime = moment(meetup.time).tz('America/Los_Angeles').format('dddd MMMM Do [at] h:mma')
	message = ":loudspeaker: *Upcoming meetup!*\n#{meetup.name} is on #{eventTime}" + ( if meetup.venue? then " located at #{meetup.venue.name} " else '' ) + "\n#{meetup.link}"
	message

generateReminder = (meetup) ->
	eventTime = moment(meetup.time).tz('America/Los_Angeles').format('h:mma')
	message = ":loudspeaker: *Reminder meetup in under 4 hours!*\n#{meetup.name} is tonight at #{eventTime}" + ( if meetup.venue? then " located at #{meetup.venue.name}" else '' ) + "\n#{meetup.link}"
	message

module.exports = (robot) ->
	meetupURL = 'https://api.meetup.com/rogue-hack-lab/events?page=4'
	eventsRoom = '#general'
	meetupBrain = robot.brain.get 'meetup'
	
	if meetupBrain is null
		meetupBrain = {announced:[],reminded:[]}
	
	setInterval () ->
		console.log 'Checking for new meetups'
		console.log meetupBrain
		
		process.env.TZ = 'UTC'
		d = new Date();
		n = d.getTime();

		robot.http(meetupURL).header('Accept', 'application/json').get() (err, res, body) ->
			if err
				console.log err
				return

			meetups = JSON.parse body
			
			if meetups and meetups.length > 0
				meetups.forEach (meetup, index, meetups) ->					

					if meetup.time < n+2*24*60*60*1000 # 2 days
						if meetup.id not in meetupBrain.announced
							announcement = generateAnnouncement(meetup)
							robot.messageRoom eventsRoom, announcement
							meetupBrain.announced.push(meetup.id)
					
					if meetup.time < n+4*60*60*1000 # 4 hrs
						if meetup.id not in meetupBrain.reminded
							reminder = generateReminder(meetup)
							robot.messageRoom eventsRoom, reminder
							meetupBrain.reminded.push(meetup.id)
					
					robot.brain.set 'meetup', meetupBrain
					
			return
		return
	, 10*60*1000 # 10 min
	return