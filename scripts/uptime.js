// Description:
//   None
//
// Dependencies:
//   None
//
// Configuration:
//   None
//
// Commands:
//   hubot uptime - Outputs bot uptime
//
// Author:
//   whitman

devRoom = process.env.DEV_ROOM;

module.exports = function(robot) {

  const start = new Date().getTime();

  if (devRoom) {
    robot.messageRoom(devRoom, "Coming back online now. Did you miss me?");
  }

  return robot.respond(/uptime/i, msg =>
    uptimeMe(msg, start, uptime => msg.send(uptime))
  );
};

const numPlural = function(num) {
  if (num !== 1) { return 's'; } else { return ''; }
};

var uptimeMe = function(msg, start, cb) {
  let response;
  const now = new Date().getTime();
  const uptime_seconds = Math.floor((now - start) / 1000);
  const intervals = {};
  intervals.day = Math.floor(uptime_seconds / 86400);
  intervals.hour = Math.floor((uptime_seconds % 86400) / 3600);
  intervals.minute = Math.floor(((uptime_seconds % 86400) % 3600) / 60);
  intervals.second = ((uptime_seconds % 86400) % 3600) % 60;

  const elements = [];
  for (let interval of Object.keys(intervals || {})) {
    const value = intervals[interval];
    if (value > 0) {
      elements.push(value + ' ' + interval + numPlural(value));
    }
  }

  if (elements.length > 1) {
    const last = elements.pop();
    response = elements.join(', ');
    response += ` and ${last}`;
  } else {
    response = elements.join(', ');
  }

  return cb(`I've been sentient for ${response}`);
};

