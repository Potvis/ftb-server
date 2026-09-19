# Java 21 is the correct default for Minecraft 1.21.x packs such as ATM10.
# Override at build time for packs that require another Java major version:
#   docker compose build --build-arg JAVA_VERSION=17
ARG JAVA_VERSION=21
FROM itzg/minecraft-server:java${JAVA_VERSION}

LABEL org.opencontainers.image.title="Minecraft Modpack Server" \
      org.opencontainers.image.description="Docker server for FTB and CurseForge Minecraft modpacks" \
      org.opencontainers.image.source="https://github.com/Potvis/ftb-server"
