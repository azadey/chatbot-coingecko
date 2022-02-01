FROM elixir:1.13 AS builder

ARG APP=chatbot
ARG MIX_ENV=prod

ENV MIX_ENV=${MIX_ENV} REPLACE_OS_VARS=true TERM=xterm

RUN set -xe \
    && apt-get update \
    && apt-get install -y --no-install-recommends apt-transport-https \
    && apt-get install -y cmake \
    && rm -rf /var/lib/apt/lists/* \
    && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
    && runtimeDeps=' \
    ' \
    && apt-get update \
    && apt-get install -y --no-install-recommends $runtimeDeps

# Install Hex and Rebar locally
RUN mix local.rebar --force \
        && mix local.hex --force

WORKDIR /opt/app

COPY . .

# Compile the Chatbot App
RUN mix do deps.get, deps.compile, compile

COPY assets assets
RUN mix assets.deploy

# Prepare the release
RUN mix release \
    && mv _build/${MIX_ENV}/rel/${APP} /opt/release \
    && mv /opt/release/bin/${APP} /opt/release/bin/server


# Set the runtime

FROM debian:11-slim


RUN set -xe \
    && fetchDeps=' \
    ca-certificates \
    libssl-dev \
    locales \
    ' \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends $fetchDeps
ENV MIX_ENV=${MIX_ENV} REPLACE_OS_VARS=true TERM=xterm
WORKDIR /opt/app

COPY --from=builder /opt/release .

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8


# Expose the server on 4000
EXPOSE 4000

CMD ["/opt/app/bin/server", "start"]