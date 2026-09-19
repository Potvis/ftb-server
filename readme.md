# Minecraft Modpack Server

A Docker Compose setup for running Feed The Beast and CurseForge Minecraft
modpacks. It defaults to **All the Mods 10** and includes an optional RCON web
console.

The image is based on
[`itzg/minecraft-server`](https://github.com/itzg/docker-minecraft-server),
which handles modpack installation, updates, loader selection, EULA acceptance,
permissions, health checks, and graceful shutdowns.

## Features

- Automatic installation and updates for CurseForge modpacks
- Automatic installation and updates for FTB modpacks
- All the Mods 10 defaults, including its recommended server-side exclusions
- Persistent server data
- Configurable Java version and memory limits
- Optional password-protected RCON web console
- RCON port isolated inside the Docker network

## Quick start: All the Mods 10

ATM10 is a **CurseForge** modpack (not SourceForge) and requires Java 21.

1. Copy the example configuration:

   ```bash
   cp .env.example .env
   ```

2. Replace `RCON_PASSWORD` and `RWA_PASSWORD` in `.env`. Generate strong values
   with:

   ```bash
   openssl rand -base64 32
   ```

3. Start the Minecraft server:

   ```bash
   docker compose up -d --build
   ```

4. Follow the first installation:

   ```bash
   docker compose logs -f minecraft
   ```

Minecraft listens on port `25565`. Server files and the world are stored in
`./data`.

By default the latest ATM10 release is selected on every restart. To pin a
version, set either `CF_FILE_ID` or `CF_FILENAME_MATCHER` in `.env`.

## Web console

Start the server together with RCON Web Admin:

```bash
docker compose --profile web up -d --build
```

Open <http://127.0.0.1:4326> on the Docker host and sign in with
`RWA_USERNAME` and `RWA_PASSWORD` from `.env`.

Both the HTTP UI and its WebSocket port bind to localhost by default. For access
from another computer, set `RCON_WEB_BIND` to the Docker host's LAN address and
allow ports 4326 and 4327 through the local firewall. For internet access, put
both endpoints behind an HTTPS reverse proxy instead of exposing them directly.
The Minecraft RCON port `25575` must never be published; the web console reaches
it over the private Compose network.

The web console can run commands, administer players, and show server status. It
does not control the Docker container itself. Use Docker Compose or Portainer for
container start, stop, restart, logs, and updates.

## Use another CurseForge modpack

Set the platform and the slug from the modpack URL in `.env`:

```dotenv
MODPACK_PLATFORM=AUTO_CURSEFORGE
CF_SLUG=all-the-mods-10
```

For `https://www.curseforge.com/minecraft/modpacks/example-pack`, the slug is
`example-pack`. Change `JAVA_VERSION` when the pack requires a Java version
other than 21, then rebuild with `docker compose up -d --build`.

Some CurseForge projects block automated downloads. If the logs list files that
need manual download, place those files in `./downloads` and restart the server.
A personal `CF_API_KEY` can optionally be placed in `.env`; never commit it.

## Use an FTB modpack

Change `.env` to:

```dotenv
MODPACK_PLATFORM=FTBA
FTB_MODPACK_ID=88
FTB_MODPACK_VERSION_ID=100026
```

`FTB_MODPACK_VERSION_ID` is optional; omit it to track the latest version. Find
the numeric pack ID in its URL on the FTB site. Older packs can require Java 8
or 17, so change `JAVA_VERSION` and rebuild when necessary.

## Changing modpacks safely

Do not install a different modpack over an existing world. Stop the stack, back
up `./data`, then either move that directory or set a different `DATA_DIR` in
`.env` before starting the new pack.

```bash
docker compose down
mv data data-backup
docker compose up -d --build
```

## Common commands

```bash
# Status
docker compose ps

# Logs
docker compose logs -f minecraft

# Stop cleanly
docker compose down

# Pull the web UI and rebuild the server image
docker compose --profile web pull
docker compose --profile web up -d --build
```

## Configuration reference

| Variable | Default | Purpose |
| --- | --- | --- |
| `MODPACK_PLATFORM` | `AUTO_CURSEFORGE` | `AUTO_CURSEFORGE` or `FTBA` |
| `CF_SLUG` | `all-the-mods-10` | CurseForge modpack slug |
| `CF_FILE_ID` | empty | Pin a CurseForge file ID |
| `CF_FILENAME_MATCHER` | empty | Pin by filename substring or regex |
| `FTB_MODPACK_ID` | empty | Numeric FTB pack ID |
| `FTB_MODPACK_VERSION_ID` | empty | Optional numeric FTB version ID |
| `JAVA_VERSION` | `21` | Java major version used to build the image |
| `INIT_MEMORY` | `4G` | Initial Java heap |
| `MAX_MEMORY` | `12G` | Maximum Java heap |
| `MINECRAFT_PORT` | `25565` | Published game port |
| `DATA_DIR` | `./data` | Persistent server directory |
| `RCON_WEB_BIND` | `127.0.0.1` | Host address for the optional web UI |

See the upstream documentation for
[Auto CurseForge](https://docker-minecraft-server.readthedocs.io/en/latest/types-and-platforms/mod-platforms/auto-curseforge/)
and [FTB](https://docker-minecraft-server.readthedocs.io/en/latest/types-and-platforms/mod-platforms/ftb/)
for advanced settings.

## License

This repository is provided as-is. Minecraft, FTB, CurseForge, and individual
modpacks are subject to their respective licenses and terms.

[![Buy Me A Coffee](https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png)](https://www.buymeacoffee.com/jayvandamme)
