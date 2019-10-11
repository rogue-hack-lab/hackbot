introduction = 'Please join hackbot in welcoming @user to the Rogue Hack Lab!!! :tada:';

icebreakers = [
  'What\'s your favorite 1990\'s cartoon?',
  'What did you have for breakfast?',
  'What\'s one skill you would like to develop?',
  'What\'s your favorite letter of the alphabet and why?',
  'How old were you when you first used a computer?',
  'What\'s your favorite spot for a beer?',
  'How did you hear about the hack lab?',
  'When was the last time you changed your hairstyle?',
  'Have you committed today?',
  'You\'re trapped on a deserted island, what TV show are you bringing to keep you company?',
  '' 
];

// Combine introduction with an icebreaker question
responses = icebreakers.map((item) => introduction + ' ' + item) + 'Start a thread with your response to get to know the hack lab better';

module.exports = responses;
