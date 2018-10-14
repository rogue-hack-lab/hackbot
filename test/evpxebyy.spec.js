const Helper = require('hubot-test-helper');
const helper = new Helper('../scripts/evpxebyy.coffee');

const co = require('co');
const { expect } = require('chai');
const rot13 = require('ebg13');

const stateKey = "evpxebby";

describe('an easter egg', () => {
  beforeEach(function() {
    this.room = helper.createRoom({name: "room1", httpd: false});
    this.otherRoom = helper.createRoom({name: "room2", httpd: false});
  });

  afterEach(function() {
    this.room.destroy();
    this.otherRoom.destroy();
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

  context('storing the chain in separate channels', function() {
    beforeEach(function() {
      return co(function*() {
        yield this.room.user.say('bob', 'I have never seen a hairless cat.');
        yield this.room.user.say('alice', "I'm gonna say that's fairly common!");
        yield this.otherRoom.user.say('bob', 'This is never gonna work! I give up.');
      }.bind(this));
    });

    // This ensures that messages stored from a channel don't leak over to
    // other channels. Technically the hubot-test-helper doesn't realistically
    // test shared brains between channels, which is why we're explicitly
    // testing the state.
    it("should trigger separate responses in each respective channel", function() {
      const state = this.room.robot.brain.get(stateKey);
      const otherState = this.otherRoom.robot.brain.get(stateKey);

      expect(state["room2"]).to.eql(undefined);
      expect(state["room1"].n).to.eql(2);
      expect(state["room1"].chain).to.eql([
        {userId: "bob", text: rot13("V unir *arire* frra n unveyrff png.")},
        {userId: "alice", text: rot13("V'z *tbaan* fnl gung'f snveyl pbzzba!")}
      ]);

      expect(otherState["room1"]).to.eql(undefined);
      expect(otherState["room2"].n).to.eql(3);
      expect(otherState["room2"].chain).to.eql([
        {userId: "bob", text: rot13("Guvf vf *arire* *tbaan* jbex! V *tvir* hc.")},
      ]);
    });
  });
});
