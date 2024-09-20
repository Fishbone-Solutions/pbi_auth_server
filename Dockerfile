# BUILD STAGE
FROM node:lts-alpine3.18@sha256:c41b5bfd0ef6f2db8f50323ce5ffb39f4ad444b5e5796c819ba4b1b799fbfdc2 AS build
WORKDIR /usr/src/app
COPY ./app /usr/src/app
RUN apk update && apk upgrade && apk add --no-cache git \
    && npm install --production && npm cache clean --force \

# PRODUCTION STAGE
FROM node:lts-alpine3.18@sha256:c41b5bfd0ef6f2db8f50323ce5ffb39f4ad444b5e5796c819ba4b1b799fbfdc2 AS production
WORKDIR /usr/src/app
COPY hs2-api.conf /etc/nginx/conf.d/hs2.conf
ENV PORT 3000
EXPOSE 3000
RUN npm install --production && npm cache clean --force \
    && npm install -g pm2
CMD ["pm2-runtime", "app.js"]