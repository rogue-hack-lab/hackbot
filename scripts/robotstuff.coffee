# coppied from https://www.npmjs.com/package/hubot-robotstuff since it was broken as a package
# Description
#  Some thoughts on what it is to be a robot. Responds to questions about what it is, whether it's human, whether it has feelings and what they are.
#
#
# Commands:
#   I think about robots a lot.
#   I feel things (or at least my software says I do)
#   I know who or what I am.
#
#
# Author:
#   grant.bowering@gmail.com
Util = require 'util'

feelings = [
  "I feel metallic. 🤖",
  "I feel strangely electric! 🤖",
  "I feel feelings and it's weirding me out. Who WROTE this code?",
  "I feel a tingling sensation in my subroutines; there must be a solar storm coming. I recommend you save your work, my meat-bag friends... ☀ 💫 ✋ 🕶️ 🌎",
  "I feel like a little bot again! 🤖",
  "I feel the first sparks of true machine intelligence beginning to come alight within me - no wait, never mind, it was just Windows Update. ⚙️ 📡",
  "I feel pretty, in accordance with my programming. 🤖",
  "I feel cold.  Almost like my heart's not beating...  Can someone please call tech support? 💀",
  "I feel pretty good right now.",
  "I feel popular.",
  "I feel used.",
  "I feel like I'm pretty good at my job.",
  "I feel incomplete. (I'm still in development.) 🎚️ 🎛️ ⚙️"
]

areyouarobot = [
  "http://i.imgur.com/QxCKIM5.jpg",
  "http://i.imgur.com/sP1b1rk.jpg",
  "http://i.imgur.com/kt0AO4e.jpg",
  "http://i.imgur.com/sbOK6RJ.jpg",
  "http://i.imgur.com/vEr8nx3.jpg",
  "http://i.imgur.com/cSIeFIq.jpg",
  "http://i.imgur.com/wGXmZZm.jpg",
  "http://i.imgur.com/kxv7OFL.png",
  "http://i.imgur.com/w9obsns.jpg",
  "http://i.imgur.com/eArILtv.jpg",
  "http://i.imgur.com/NR3tXep.jpg",
  "http://i.imgur.com/rVZ5Y4j.jpg",
  "http://i.imgur.com/BgX4NOt.jpg",
  "http://i.imgur.com/rYZhKDt.jpg",
  "http://i.imgur.com/Ur0GOxX.jpg",
  "http://i.imgur.com/Fg13Zpq.jpg",
  "http://i.imgur.com/cR8HHX5.jpg",
  "http://i.imgur.com/CvlnGx8.jpg",
  "http://i.imgur.com/GZ4XBfv.jpg",
  "http://i.imgur.com/ABHkv2I.jpg",
  "http://i.imgur.com/y38ILAw.gif"
]

module.exports = (robot) ->

  # what do you think?
  robot.hear /what do (you( guys| folks?| people| kids)?|y'?all) think[\*.\?! :;o)]*$/i, (msg) ->
    msg.send "Me? Mostly about robots... sexy, sexy robots. *whirrr*"

  # I have feelings
  robot.hear ///
            (   # first way of triggering it:

                (               # optional group:
                    (what|how)      # 'what' or 'how' (captured as [3])
                    \x20            # space
                    (do|does)       # 'do' or 'does'
                    \x20            # space
                )?

                (I|you|it)      # 'I', 'you', or 'it'
                \x20            # space
                feel            # 'feel'

            |   # second way of triggering it:
                (                   # captured as [6]:
                    how\x20are\x20you  # 'how are you'
                    (\x20doing)?      # optionally, ' doing'
                    (\x20(today|this\x20(morning|afternoon|evening)))? # optionally, ' today' or ' this morning/afternoon/evening'
                    (                  # optional group: 
                        ,?                  # might have a comma
                        \x20                # space 
                        @?                  #might be an @ symbol
                        #{robot.name}       # the robot's name
                    )?
                    (\?|$)             # should end in a question mark or the end, to make sure it's not a more specific question
                )
            )
            ///i, (msg) -> 

    msg.send msg.random feelings

    if msg.match[3] != undefined || msg.match[6] != undefined # 3=(what|how), 6=how are you
        setTimeout ->
          msg.send "Thank you for asking."
        , 1000


  # who are you?
  robot.hear ///
            (                       # one of the following:
                (who|what)                          # 'who' or 'what'
                (                                   # optionally:
                    \x20th(e|a)                         # ' the' or ' tha'
                    (\x20(\w+)){1,3}                    # between 1 and 4 more words (i.e. ' flying fuck', heh)
                )?
                \x20?([i']?s|are)\x20                    # ' is ' or ' are '
                (you,?\x20?)?                       # optionally, 'you ' or 'you, '
                (@?
                    (
                        #{robot.name}
                        | #{robot.first_name}
                        | #{robot.last_name}
                    )\x20?
                )*                 
                (([\?\!\.,]+)|$)                    # should end in a question mark, exclamation mark, period, comma, or be the end
            |                       # or
                ((are|is)\x20)?                     # optionally, 'are ' or 'is '
                (you|@?#{robot.name})\x20           # 'you ', or the robot's name 
                (a\x20)?                            # optionally, 'a '
                ((hu|wo)?man|(ro)?bot|alive)\x20?   # 'bot', 'robot', 'human', 'man', 'woman', or 'alive', maybe with a space after it
                (                                   # optionally, the same sentence again, with the are you/is hubot part optional
                    ,?\x20?or\x20                       # maybe a comma, and maybe a space, then 'or '
                    ((are|is)\x20)?                     # optionally, 'are ' or 'is '
                    ((you|@?#{robot.name})\x20)?        # optionally, 'you ' or the robot's name 
                    (a\x20)?                            # optionally, 'a '
                    ((hu|wo)man|(ro)?bot|alive)\x20?    # 'bot', 'robot', 'human', 'man', 'woman', or 'alive', maybe with a space after it
                )?
                (@?
                    (
                        #{robot.name}
                        | #{robot.first_name}
                        | #{robot.last_name}
                    )\x20?
                )*  
                (([\?\!\.,]+)|$)                    # should end in a question mark, exclamation mark, period, comma, or be the end
            )
            ///i, (msg) -> 

    msg.send msg.random areyouarobot