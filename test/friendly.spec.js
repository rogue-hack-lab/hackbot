const Helper = require('hubot-test-helper');
const helper = new Helper('../scripts/friendly.coffee');

const co = require('co');
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
      beforeEach(function() {
        return co(function*() {
          yield this.room.user.say('someone', hello);
        }.bind(this));
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
