const Helper = require('hubot-test-helper');
const helper = new Helper('../scripts/dice-roller.js');

const { expect } = require('chai');

describe('hackbot dice roller', () => {
  beforeEach(function() {
    this.room = helper.createRoom();
  });

  afterEach(function() {
    this.room.destroy();
  });

  context('of a 1d20', function () {
    beforeEach(async function() {
      await this.room.user.say('josh', 'roll 2d20');
    });

    it('hackbot should roll dice', function() {
      expect(this.room.messages[1][1]).to.match(/@josh You rolled [0-9]+, [0-9]+ for a total of: [0-9]+/i)
    });
  });
});
