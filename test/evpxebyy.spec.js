const Helper = require('hubot-test-helper');
const helper = new Helper('../scripts/evpxebyy.coffee');

const co = require('co');
const { expect } = require('chai');
const rot13 = require('ebg13');

describe('an easter egg', () => {
  beforeEach(function() {
    this.room = helper.createRoom();
  });

  afterEach(function() {
    this.room.destroy();
  });

  context('completing the chain', function() {
    beforeEach(function() {
      return co(function*() {
        yield this.room.user.say('bob', 'I have never seen a hairless cat.');
        yield this.room.user.say('alice', "I'm gonna say that's fairly common!");
        yield this.room.user.say('joe', "Give it time, you will eventually meet one.");
        yield this.room.user.say('jayne', "I actually had a hairless cat growing up.");
      }.bind(this));
    });

    it("should trigger a reponse", function() {
      const expectedResponse = rot13("Evpxebyy punva qrgrpgrq!\n\n@obo fnvq \"V unir *arire* frra n unveyrff png.\"\n@nyvpr fnvq \"V'z *tbaan* fnl gung'f snveyl pbzzba!\"\n@wbr fnvq \"*Tvir* vg gvzr, *lbh* jvyy riraghnyyl zrrg bar.\"\n@wnlar fnvq \"V npghnyyl unq n unveyrff png tebjvat *hc*.\"");

      expect(this.room.messages).to.eql([
        ["bob", "I have never seen a hairless cat."],
        ["alice", "I'm gonna say that's fairly common!"],
        ["joe", "Give it time, you will eventually meet one."],
        ["jayne", "I actually had a hairless cat growing up."],
        ["hubot", expectedResponse],
      ]);
    });
  });
});
