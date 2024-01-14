FROM node:12.6.0-alpine
RUN apk update && apk add git

RUN mkdir /app
COPY . /app
EXPOSE 3000
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH

RUN yarn

CMD ["npm", "start"]