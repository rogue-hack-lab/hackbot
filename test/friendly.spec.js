const Helper = require('hubot-test-helper');
const helper = new Helper('../scripts/friendly.coffee');

const { expect } = require('chai');

const hellos = [
  "Hi!",
  "hey",
  "Hello.",
  "greetings friends",
  "Hello, everyone",
  "What's up, friends?"
];

describe('friendly', () => {
  beforeEach(function() {
    this.room = helper.createRoom();
  });

  afterEach(function() {
    this.room.destroy();
  });

  hellos.forEach(function(hello) {
    context(`when someone says "${hello}"`, function() {
      beforeEach(async function() {
        await this.room.user.say('someone', hello);
      });

      it("should greet back", function() {
        expect(this.room.messages).to.eql([
          ["someone", hello],
          ["hubot", "Hi @someone!"]
        ]);
      });
    });
  });
});
