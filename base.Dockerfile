FROM rust:latest as buildstep

###################################
### sccache configuration start ###
###################################

ARG SCCACHE_GHA_ENABLED
ARG ACTIONS_CACHE_URL=""
ARG ACTIONS_RUNTIME_TOKEN=""

RUN if [ "$SCCACHE_GHA_ENABLED" = "on" ]; then curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash; fi
RUN if [ "$SCCACHE_GHA_ENABLED" = "on" ]; then cargo binstall -y sccache; fi

# if --build-arg SCCACHE_GHA_ENABLED=on, set RUSTC_WRAPPER to 'sccache' or set to null otherwise.
# stolen from https://stackoverflow.com/a/51264575
ENV RUSTC_WRAPPER=${SCCACHE_GHA_ENABLED:+sccache}

###################################
### sccache configuration end   ###
###################################

RUN cargo run
