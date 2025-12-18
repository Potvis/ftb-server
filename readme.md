# FTB Minecraft Server Docker Image

A Docker image for running Feed The Beast (FTB) Minecraft modpack servers with easy configuration.

## Features

- Automatic modpack installation from FTB API
- Configurable pack and version via environment variables
- Automatic EULA acceptance
- Optimized Java arguments for performance
- Persistent data storage

## Quick Start

```yaml
services:
  ftb-server:
    image: pvmjay/ftb-server:latest
    container_name: ftb-server
    restart: unless-stopped
    ports:
      - "25565:25565"
    volumes:
      - ./data:/data
    environment:
      - FTB_PACK_ID=88           # FTB Academy
      - FTB_PACK_VERSION=100026
    stdin_open: true
    tty: true
```

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `FTB_PACK_ID` | `88` | The FTB modpack ID (FTB Academy by default) |
| `FTB_PACK_VERSION` | `100026` | The modpack version |
| `JAVA_OPTS` | (optimized) | Java JVM arguments |

### Finding Pack IDs and Versions

To find the pack ID and version for your desired modpack:

1. Visit [feed-the-beast.com](https://www.feed-the-beast.com/)
2. Find your desired modpack
3. Check the URL or modpack details for the pack ID
4. Select the version you want to use

### Common FTB Modpacks

| Modpack | Pack ID | Example Version |
|---------|---------|-----------------|
| FTB Academy | 88 | 100026 |
| FTB Revelation | 35 | 12180 |
| FTB Continuum | 34 | 149 |
| FTB Infinity Evolved | 23 | 99 |

## Usage

### Using Docker Compose (Recommended)

1. Create a `docker-compose.yml` file:

```yaml
services:
  ftb-server:
    image: pvmjay/ftb-server:latest
    container_name: ftb-server
    restart: unless-stopped
    user: "1000:1000"
    ports:
      - "25565:25565"
    volumes:
      - ./data:/data
    environment:
      - FTB_PACK_ID=88
      - FTB_PACK_VERSION=100026
      - JAVA_OPTS=-Xms2G -Xmx16G -XX:+UseG1GC
    stdin_open: true
    tty: true
    mem_limit: 18g
    mem_reservation: 16g
```

2. Start the server:
```bash
docker-compose up -d
```

3. View logs:
```bash
docker-compose logs -f
```

### Using Docker Run

```bash
docker run -d \
  --name ftb-server \
  -p 25565:25565 \
  -v ./data:/data \
  -e FTB_PACK_ID=88 \
  -e FTB_PACK_VERSION=100026 \
  --restart unless-stopped \
  pvmjay/ftb-server:latest
```

## Memory Requirements

Different modpacks have different memory requirements. Adjust `mem_limit`, `mem_reservation`, and the `-Xmx` value in `JAVA_OPTS` based on your modpack:

- **Light modpacks**: 4-8GB
- **Medium modpacks**: 8-12GB
- **Heavy modpacks**: 12-16GB+

## Ports

- `25565` - Minecraft server port

## Volumes

- `/data` - Server files, world data, configs, and mods

## First Run

On the first run, the container will:
1. Download the modpack installer
2. Install the modpack
3. Accept the EULA automatically
4. Start the server

This process may take several minutes depending on the modpack size.

## Accessing Server Console

```bash
docker attach ftb-server
```

To detach without stopping the server, press `Ctrl+P` then `Ctrl+Q`.

## Troubleshooting

### Server won't start
- Check logs: `docker logs ftb-server`
- Ensure you have enough memory allocated
- Verify pack ID and version are correct

### Permission issues
- Ensure the mounted volume has correct permissions
- Adjust the `user` parameter in docker-compose to match your host user

### Out of memory errors
- Increase `mem_limit` and `-Xmx` in `JAVA_OPTS`

## License

This image is provided as-is. Feed The Beast modpacks are subject to their own licenses.

## Support

For issues or questions, please open an issue on the GitHub repository.

