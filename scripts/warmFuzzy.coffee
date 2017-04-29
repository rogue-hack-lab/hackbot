// Description:
//   A simple hubot that keeps track of WF. (http://www.claudesteiner.com/fuzzy.htm)
//
// Commands:
//   hubot WF list
//   @[subject]++
//
// Author:
//   Adapted from HerrPfister hubot-WF

function sendWFMessage(robot, res, WFAmount) {
    var subject = res.match[1] || res.match[2];

    var WFKeys = robot.brain.get('keys') || [];

    var oldWFAmount = parseInt(robot.brain.get('wf-'+subject)) || 0;
    var newWFAmount = oldWFAmount + WFAmount;

    var WFText = "not changed";

    robot.brain.set('wf-'+subject, newWFAmount);

    if (WFKeys.indexOf('wf-'+subject) < 0) {
        WFKeys.push('wf-'+subject);
        robot.brain.set('keys', WFKeys);
    }

    if (oldWFAmount < newWFAmount) {
        WFText = "increased to {amount}".replace("{amount}", newWFAmount.toString());
    } else if (oldWFAmount > newWFAmount) {
        WFText = "decreased to {amount}".replace("{amount}", newWFAmount.toString());
    }

    res.send("{subject}\'s has {WFText} warm fuzzy."
        .replace("{subject}", subject)
        .replace("{WFText}", WFText));
}

module.exports = function (robot) {
    robot.respond(/(Warm\s?Fuzz(y|ies|)|wf) list/i, function (res) {
        var WFKeys = robot.brain.get('keys');

        var messages = WFKeys.map(function (key) {
            var val = robot.brain.get(key);

            return "{key} = {value}".replace("{key}", key).replace("{value}", val);
        });

        res.send(messages.join("\n"));
    });

    robot.hear(/\s*(@\w+)\s?[+]{2}[+]*/i, function (res) {
        var plusCount = (res.message.text.match(/[+]/g) || []).length;
        var positiveWFAmount = plusCount > 2 ? plusCount - 1 : 1;

        sendWFMessage(robot, res, positiveWFAmount);
    });

    robot.hear(/\s*(@\w+)\s?[-]{2}[-]*/i, function (res) {
        var minusCount = (res.message.text.match(/[-]/g) || []).length;
        var negativeWFAmount = -(minusCount > 2 ? minusCount - 1 : 1);

        sendWFMessage(robot, res, negativeWFAmount);
    });
};

