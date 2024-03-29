FROM node:14-alpine

LABEL com.centurylinklabs.watchtower.stop-signal="SIGQUIT"

RUN apk add --no-cache git && git --version

COPY package.json ./
RUN npm install --production

COPY . .

ENV HUBOT_ADAPTER slack
ENV HUBOT_SLACK_TOKEN **CHANGEME**

CMD bin/hubot
