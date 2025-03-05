# Use the base n8n image
FROM docker.n8n.io/n8nio/n8n

# Switch to root user to install packages
USER root

# Install Bash, Python, and required build tools
RUN apk add --no-cache bash python3 py3-pip py3-virtualenv gcc python3-dev musl-dev linux-headers

# Switch to node user
USER node

# Define home directory variables
ENV NODE_HOME="/home/node"
ENV AIDER_VENV="$NODE_HOME/aider-venv"

# Ensure ~/.local/bin exists and is writable
RUN mkdir -p $NODE_HOME/.local/bin

# Add ~/.local/bin to PATH
ENV PATH="$NODE_HOME/.local/bin:$AIDER_VENV/bin:$PATH"

# Install aider in the virtual environment
RUN python3 -m venv $AIDER_VENV \
    && $AIDER_VENV/bin/pip install --no-cache-dir aider-install \
    && $AIDER_VENV/bin/aider-install || true  # Ignore errors from `uv tool update-shell`

# Ensure correct permissions
RUN chown -R node:node $NODE_HOME/.local $AIDER_VENV
