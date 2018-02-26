const Helper = require('hubot-test-helper');
const helper = new Helper('../scripts/greetings.coffee');

const enterReplies = require('../stubs/enterReplies');
const leaveReplies = require('../stubs/leaveReplies');

const { expect } = require('chai');

describe('hellogoodbye', () => {
  beforeEach( () => this.room = helper.createRoom() )

  afterEach( () => this.room.destroy() )

  it('hackbot should say one of the random hellos', () => {
    this.room.user.enter('')
      .then(() => expect(this.room.messages[0][1]).oneOf(enterReplies))
  });

  it('hackbot should say one of the random goodbyes', () => {
    this.room.user.leave('')
      .then(() => expect(this.room.messages[0][1]).oneOf(leaveReplies))
  });
});

  