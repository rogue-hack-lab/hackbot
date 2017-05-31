FROM node:alpine

COPY package.json ./
RUN npm install --production

COPY . .

ENV HUBOT_ADAPTER slack
ENV HUBOT_SLACK_TOKEN **CHANGEME**

CMD bin/hubot