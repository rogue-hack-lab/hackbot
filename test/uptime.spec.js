const Helper = require('hubot-test-helper');
const helper = new Helper('../scripts/uptime.js');

const { expect } = require('chai');

describe('uptime', () => {
  
  beforeEach( () => this.room = helper.createRoom() )
  
  afterEach( () => this.room.destroy() )

  it('seconds', () => {
    this.room.user.say('kevin', '@hubot uptime')
    .then( () => {
      expect (this.room.messages).to.eql([
        ['kevin', '@hubot uptime'],
        ['hubot', 'I\'ve been sentient for ']
      ] )
    })
  }); 

});
