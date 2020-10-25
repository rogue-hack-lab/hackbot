icebreakers = [
  'What\'s your favorite 1990\'s cartoon?',
  'What did you have for breakfast?',
  'What\'s one skill you would like to develop?',
  'What\'s your favorite letter of the alphabet and why?',
  'How old were you when you first used a computer?',
  'How did you hear about the hack lab?',
  'When was the last time you changed your hairstyle?',
  'Have you committed code today?',
  'You\'re trapped on a deserted island, what TV show are you bringing to keep you company?',
  'What\'s your favorite flavor of sparkling water?',
  'Tell us your favorite \'nerdy\' joke',
  'Share your favorite color (in hexcode!)',
  'What website do you suddenly find yourself on when you\'re \"just checking your email\"?',
  'If you could be any other species, which would you choose?',
  'What superpower would you want?',
  'What\'s your patronus?'
];

module.exports = (robot) ->
  robot.enter (res) ->
    if res.message.room == 'C0E03CTRT' #general
      user = res.message.user.name
      res.send res.random icebreakers.map((m) => 'Please join me in welcoming @' + user + ' to the Rogue Hack Lab!!! :tada: ' + m + ' Start a thread with your response to get to know the hack lab better');
