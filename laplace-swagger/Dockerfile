FROM node:16.15.0-bullseye
WORKDIR /build
COPY package.json /build/package.json
COPY yarn.lock /build/yarn.lock
COPY .yarn/releases /build/releases
RUN yarn install --production && \
    mv node_modules /node_modules && \
    yarn
COPY bin /build/bin
RUN ./bin/hasura-cli --skip-update-check version
COPY tsconfig.json /build/tsconfig.json
COPY env /build/env
COPY src /build/src
ARG TARGET_ENV
RUN yarn use $TARGET_ENV && \
    yarn build && \
    wc -l dist/main.js

FROM node:16.15.0-bullseye
WORKDIR /app
COPY package.json /app/package.json
COPY --from=0 /node_modules /app/node_modules
COPY --from=0 /build/dist /app/dist
COPY --from=0 /build/bin /app/bin
COPY hasura-schema /app/hasura-schema
ENTRYPOINT /app/bin/start-cli
