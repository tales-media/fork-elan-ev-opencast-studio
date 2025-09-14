ARG NODE_VERSION=17
FROM node:${NODE_VERSION}-alpine AS build

WORKDIR /src
COPY package.json .
COPY package-lock.json .
RUN npm ci
COPY / .

ARG PUBLIC_PATH=/studio
ARG SETTINGS_PATH=/ui/config/studio/settings.toml
ARG VERSION=unknown
ARG BUILD_DATE=unknown
ARG GIT_COMMIT=unknown
RUN COMMIT_SHA=${GIT_COMMIT} npm run build:release


FROM rg.nl-ams.scw.cloud/shio-solutions/infra/static-site:1

ARG PUBLIC_PATH=/studio
ARG VERSION=unknown
ARG BUILD_DATE=unknown
ARG GIT_COMMIT=unknown

COPY --from=build /src/build "/www/${PUBLIC_PATH}"

LABEL maintainer="shio solutions GmbH <dev@shio.solutions>" \
      org.opencontainers.image.title="Opencast Studio" \
      org.opencontainers.image.description="Web-based recording studio for Opencast" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.vendor="shio solutions GmbH" \
      org.opencontainers.image.authors="shio solutions GmbH <dev@shio.solutions>" \
      org.opencontainers.image.licenses="Apache-2.0" \
      org.opencontainers.image.url="https://github.com/tales-media/fork-opencast-studio" \
      org.opencontainers.image.documentation="https://github.com/tales-media/fork-opencast-studio" \
      org.opencontainers.image.source="https://github.com/tales-media/fork-opencast-studio" \
      org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.revision="${GIT_COMMIT}"
