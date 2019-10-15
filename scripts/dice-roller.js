module.exports = function(robot) {
    robot.hear(/roll ([0-9]+)d([0-9]+)/i, (response) => {
        
        let dice = {
            count: response.match[1],
            sides: response.match[2]
        };

        if (dice.count > 100) {
            response.reply(`I don't like to roll more than 100 dice.`);
            return;
        }

        let result = [];
        for (let i =0; i <= dice.count-1; i++) {
            result.push(generateRandom(dice.sides))
        }

        let total = result.reduce(aggregator);

        response.reply(`You rolled ${result.join(', ')} for a total of: ${total}`);
    });

    let generateRandom = (max) => Math.floor(Math.random() * max) + 1;
    let aggregator = (aggregate, value) => aggregate + value;
};