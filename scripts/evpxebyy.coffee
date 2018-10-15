# Description:
#   An easter egg.
#
# Notes:
#   If you really want to spoil it, all you need is ROT13 to
#   figure it out. Just don't spoil it for others, please :)
#
#   If you want to be adventurous, try to figure it out from the code without
#   decoding!

rot13 = require('ebg13')

header = rot13("Evpxebyy punva qrgrpgrq!\n\n")
words = ['arire', 'tbaan', 'tvir', 'lbh', 'hc'].map((w) => rot13(w))
stateKey = "evpxebby"

module.exports = (robot) ->
  robot.hear new RegExp(words.join("|"), "i"), (msg) ->
    room = msg.message.room
    userId = msg.message.user.id
    text = msg.message.text
    state = robot.brain.get(stateKey) || {}
    state[room] = state[room] || {n: 0, chain: []}
    score = 0

    for word, index in words.slice(state[room].n)
      pattern = new RegExp("\\b#{word}\\b", "i")
      match = text.match(pattern)
      if match?
        if index > score then break
        text = text.replace(pattern, "*#{match[0]}*")
        score += 1

    if score > 0 and score < words.length
      state[room].n += score
      state[room].chain.push
        userId: userId
        text: text
      robot.brain.set(stateKey, state)

    if state[room].n >= words.length
      resp = header + state[room].chain.map((c) => "@#{c.userId} said \"#{c.text}\"").join("\n")
      msg.send(resp)
      robot.brain.set(stateKey[room], null)
