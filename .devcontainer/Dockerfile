# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.236.0/containers/javascript-node/.devcontainer/base.Dockerfile

ARG VARIANT="16-bullseye"
FROM mcr.microsoft.com/vscode/devcontainers/javascript-node:0-${VARIANT}

# Install docsify-cli
RUN su node -c "npm install -g docsify-cli"