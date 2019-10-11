introduction = 'Please join me in welcoming @user to the Rogue Hack Lab!!! :tada:';

icebreakers = [
  'What\'s your favorite 1990\'s cartoon?',
  'What did you have for breakfast?',
];

// Combine introduction with an icebreaker question
responses = icebreakers.map((item) => introduction + ' ' + item);

module.exports = responses;
