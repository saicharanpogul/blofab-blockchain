FROM node:10.24
WORKDIR /usr/src/app
COPY package*.json ./
RUN apt-get update || : && apt-get install python -y
RUN npm install
COPY . .
EXPOSE 7080
CMD [ "node", "server.js" ]