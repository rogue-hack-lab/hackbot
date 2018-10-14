const Helper = require('hubot-test-helper');
const helper = new Helper('../scripts/warmFuzzy.coffee');

const co = require('co');
const { expect } = require('chai');

describe('warm fuzzies', () => {
  beforeEach(function() {
    this.room = helper.createRoom();
  });

  afterEach(function() {
    this.room.destroy();
  });

  context('someone giving another user a warm fuzzy', function() {
    beforeEach(function() {
      return co(function*() {
        yield this.room.user.say('bob', 'Darth Vader really was the chosen one, in the end.');
        yield this.room.user.say('alice', '@bob++');
      }.bind(this));
    });

    it("should increase the recipient's warm fuzzies", function() {
      const warmFuzzy = this.room.robot.brain.get('warmFuzzy');
      expect(warmFuzzy['@bob']).to.eql(1);
    });

    it('should reply with the new warm fuzzy count', function() {
      expect(this.room.messages).to.eql([
        ["bob", "Darth Vader really was the chosen one, in the end."],
        ["alice", "@bob++"],
        ["hubot", "@bob's has increased to 1 Warm Fuzzy."]
      ]);
    });
  });

  context('someone giving another user a cold scratchy', function() {
    beforeEach(function() {
      return co(function*() {
        yield this.room.user.say('chad', 'Jar Jar is my favorite Star Trek character.');
        yield this.room.user.say('alice', '@chad--');
      }.bind(this));
    });

    it("should decrease the recipient's warm fuzzies", function() {
      const warmFuzzy = this.room.robot.brain.get('warmFuzzy');
      expect(warmFuzzy['@chad']).to.eql(-1);
    });

    it('should reply with the new warm fuzzy count', function() {
      expect(this.room.messages).to.eql([
        ["chad", "Jar Jar is my favorite Star Trek character."],
        ["alice", "@chad--"],
        ["hubot", "@chad's has decreased to -1 Warm Fuzzy."]
      ]);
    });
  });

  context('asking for the warm fuzzies list', function() {
    beforeEach(function() {
      return co(function*() {
        this.room.robot.brain.set('warmFuzzy', {
          '@bob': 2,
          '@alice': 3
        });
        yield this.room.user.say('bob', '@hubot warm fuzzy list');
      }.bind(this));
    });

    it("should reply with a list of each user's warm fuzzies", function() {
      expect(this.room.messages).to.eql([
        ["bob", "@hubot warm fuzzy list"],
        ["hubot", "@bob = 2\n@alice = 3\n"]
      ]);
    });
  });
});
