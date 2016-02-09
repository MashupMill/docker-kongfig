FROM node:5-slim

WORKDIR /config

ENV BETWEEN_START_DELAY=2 \
    POST_START_DELAY=5 \
    CHECK_ATTEMPTS=20

COPY ./entrypoint.sh /usr/local/bin/entrypoint

RUN npm install kongfig -g ; chmod a+x /usr/local/bin/entrypoint

ENTRYPOINT ["entrypoint"]
