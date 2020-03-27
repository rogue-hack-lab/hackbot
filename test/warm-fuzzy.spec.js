const Helper = require('hubot-test-helper');
const helper = new Helper('../scripts/warmFuzzy.coffee');

const { expect } = require('chai');

describe('warm fuzzies', () => {
  beforeEach(function() {
    this.room = helper.createRoom();
  });

  afterEach(function() {
    this.room.destroy();
  });

  context('someone giving another user a warm fuzzy', function() {
    beforeEach(async function() {
      await this.room.user.say('bob', 'Darth Vader really was the chosen one, in the end.');
      await this.room.user.say('alice', '@bob++');
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
    beforeEach(async function() {
      await this.room.user.say('chad', 'Jar Jar is my favorite Star Trek character.');
      await this.room.user.say('alice', '@chad--');
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

  context('someone giving out warm fuzzies to multiple users at once', function() {
    beforeEach(async function() {
      this.room.robot.brain.set('warmFuzzy', {
        '@a': 1,
        '@b': 3,
        '@c': 5,
        '@d': 5
      });
      await this.room.user.say('bob', '@a++ @b+++ @c++ @d--');
    });

    it("should adjust each recipient's warm fuzzies", function() {
      const warmFuzzy = this.room.robot.brain.get('warmFuzzy');
      expect(warmFuzzy['@a']).to.eql(2);
      expect(warmFuzzy['@b']).to.eql(5);
      expect(warmFuzzy['@c']).to.eql(6);
      expect(warmFuzzy['@d']).to.eql(4);
    });

    it('should reply with the new warm fuzzy counts', function() {
      expect(this.room.messages).to.eql([
        ["bob", "@a++ @b+++ @c++ @d--"],
        ["hubot", "@a's has increased to 2 Warm Fuzzies."],
        ["hubot", "@b's has increased to 5 Warm Fuzzies."],
        ["hubot", "@c's has increased to 6 Warm Fuzzies."],
        ["hubot", "@d's has decreased to 4 Warm Fuzzies."]
      ]);
    });
  });

  context('someone trying to give themself a warm fuzzy', function() {
    beforeEach(async function() {
      this.room.robot.brain.set('warmFuzzy', {
        '@alice': 1
      });
      await this.room.user.say('alice', '@alice++');
    });

    it('should not increase their own warm fuzzies', function() {
      const warmFuzzy = this.room.robot.brain.get('warmFuzzy');
      expect(warmFuzzy['@alice']).to.eql(1);
    });

    it('should reply with the reason', function() {
      expect(this.room.messages).to.eql([
        ["alice", "@alice++"],
        ["hubot", "Warm fuzzies are meant to be given to others."]
      ]);
    });
  });

  context('someone trying to give themself a cold scratchy', function() {
    beforeEach(async function() {
      this.room.robot.brain.set('warmFuzzy', {
        '@alice': 2
      });
      await this.room.user.say('alice', '@alice--');
    });

    it('should not decrease their own warm fuzzies', function() {
      const warmFuzzy = this.room.robot.brain.get('warmFuzzy');
      expect(warmFuzzy['@alice']).to.eql(2);
    });

    it('should reply with the reason', function() {
      expect(this.room.messages).to.eql([
        ["alice", "@alice--"],
        ["hubot", "Aww, don't be so hard on yourself."]
      ]);
    });
  });

  context('asking for the warm fuzzies list', function() {
    beforeEach(async function() {
      this.room.robot.brain.set('warmFuzzy', {
        '@bob': 2,
        '@alice': 3
      });
      await this.room.user.say('bob', '@hubot warm fuzzy list');
    });

    it("should reply with a list of each user's warm fuzzies", function() {
      expect(this.room.messages).to.eql([
        ["bob", "@hubot warm fuzzy list"],
        ["hubot", "@bob = 2\n@alice = 3\n"]
      ]);
    });
  });
});
