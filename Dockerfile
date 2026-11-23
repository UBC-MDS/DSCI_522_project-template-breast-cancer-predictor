# Adapted from docker-uv-renv by Daniel Chen (MIT License)
# https://github.com/chendaniely/docker-uv-renv

# Start from Ubuntu Linux (this image also has R, which you can ignore).
FROM rocker/r-ver:4.6.2

# Install the programs the project needs:
# curl downloads files, git/less/nano let you work in a terminal,
# make runs a Makefile, openssh-server lets Positron connect over ssh
RUN apt-get update && apt-get install --yes \
    curl \
    git \
    less \
    make \
    nano \
    openssh-server

# Install Quarto (it comes with Typst for PDFs, so no LaTeX).
# dpkg --print-architecture gives amd64 or arm64, to match the computer.
RUN curl --location --output quarto.deb \
    https://github.com/quarto-dev/quarto-cli/releases/download/v1.11.9/quarto-1.11.9-linux-$(dpkg --print-architecture).deb \
  && apt-get install --yes ./quarto.deb \
  && rm quarto.deb

# Copy the uv program into the image (0.13.7 pins uv's version)
COPY --from=ghcr.io/astral-sh/uv:0.13.7 /uv /uvx /usr/local/bin/

# Your project folder is mounted at /workspace,
# so the packages go in /opt instead
WORKDIR /workspace

# Python packages (uv) go in /opt/venv
ENV UV_PROJECT_ENVIRONMENT=/opt/venv
# ssh logins don't see ENV, only /etc/environment
RUN echo "UV_PROJECT_ENVIRONMENT=$UV_PROJECT_ENVIRONMENT" >> /etc/environment
COPY pyproject.toml uv.lock .python-version ./
# --locked: stop if uv.lock doesn't match pyproject.toml
RUN uv sync --locked

# On a Linux laptop, remove the # from the next line.
# (sshd wants root to own the key file, but on Linux the mounted one is yours.)
# RUN echo "StrictModes no" > /etc/ssh/sshd_config.d/container.conf

# Start the ssh server when the container starts.
# -D keeps it in the foreground, so the container keeps running.
CMD ["/usr/sbin/sshd", "-D"]
