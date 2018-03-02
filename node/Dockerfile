FROM node:carbon

# Create app directory
WORKDIR /app/node-api

RUN npm install -g gulp gulp-cli pm2

CMD [ "npm", "run", "dev" ]