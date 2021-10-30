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
//   hubot helium endpoint - Say the Helium Blockchain API's endpoint
//   hubot helium price - Say the current Helium Oracle price
//   hubot helium in {city} - Say the number of Helium hotspots in a city
//
// Author:
//   xtagon

module.exports = function(robot) {
  const { Client } = require("@helium/http");

  const client = new Client();

  robot.respond(/helium\s+endpoint/i, (res) => {
    const { endpoint } = client.network;
    res.send(`The Helium Blockchain API I'm connected to is: ${endpoint}`);
  });

  robot.respond(/helium\s+price/i, async (res) => {
    const currentPrice = await client.oracle.getCurrentPrice();
    const priceString = currentPrice.price.toString();
    const { timestamp } = currentPrice;
    res.send(`The price of Helium is: ${priceString} (as of ${timestamp})`);
  });

  robot.respond(/helium\s+in\s+(\w.*)/i, async (res) => {
    const query = res.match[1];
    const list = await client.cities.list({query});
    const cities = await list.take(1);
    const cityWasFound = cities && cities.length > 0;

    if (cityWasFound) {
      const city = cities[0];

      res.send(`There are ${city.hotspotCount} hotspots in ${city.shortCity}, ${city.shortState}, ${city.shortCountry}. ${city.onlineCount} are online and ${city.offlineCount} are offline.`);
    } else {
      res.send(`I don't know about any Helium hotspots in that city.`);
    }

  });

  return robot;
}
