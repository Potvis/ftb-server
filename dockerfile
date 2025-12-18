FROM eclipse-temurin:25-jre

# Install necessary tools
RUN apt-get update && \
    apt-get install -y wget curl expect && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create minecraft user and directories
RUN useradd -m minecraft && \
    mkdir -p /data && \
    chown -R minecraft:minecraft /data

# Default environment variables for FTB pack
ENV FTB_PACK_ID=88
ENV FTB_PACK_VERSION=100026

# Create startup script in /usr/local/bin
RUN printf '#!/bin/bash\n\
\n\
cd /data\n\
\n\
if [ ! -f "start.sh" ] && [ ! -f "startserver.sh" ] && [ ! -f "forge-*.jar" ]; then\n\
    echo "Server not found. Installing FTB modpack..."\n\
    echo "Pack ID: ${FTB_PACK_ID}"\n\
    echo "Pack Version: ${FTB_PACK_VERSION}"\n\
    wget -O serverinstall "https://api.feed-the-beast.com/v1/modpacks/public/modpack/${FTB_PACK_ID}/${FTB_PACK_VERSION}/server/linux"\n\
    chmod +x serverinstall\n\
    \n\
    # Run installer with correct flags\n\
    ./serverinstall -pack ${FTB_PACK_ID} -version ${FTB_PACK_VERSION} -dir . -auto -accept-eula -force\n\
    \n\
    rm -f serverinstall\n\
    echo "Installation complete!"\n\
fi\n\
\n\
echo "eula=true" > eula.txt\n\
\n\
if [ -f "start.sh" ]; then\n\
    echo "Starting server with start.sh..."\n\
    exec sh start.sh\n\
elif [ -f "startserver.sh" ]; then\n\
    echo "Starting server with startserver.sh..."\n\
    exec sh startserver.sh\n\
elif [ -f "run.sh" ]; then\n\
    echo "Starting server with run.sh..."\n\
    exec sh run.sh\n\
else\n\
    echo "ERROR: No start script found!"\n\
    echo "Available files in directory:"\n\
    ls -la\n\
    exit 1\n\
fi\n' > /usr/local/bin/startup.sh && \
    chmod +x /usr/local/bin/startup.sh

# Set working directory
WORKDIR /data

# Switch to minecraft user
USER minecraft

# Expose Minecraft port
EXPOSE 25565

# Start command
CMD ["/bin/bash", "/usr/local/bin/startup.sh"]