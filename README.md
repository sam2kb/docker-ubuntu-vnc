# A small Ubuntu container with "headless" VNC session and Xfce4 desktop

This work is a simplified and refactored version of https://github.com/ConSol/docker-headless-vnc-container
Latest Ubuntu 18.04, updated installers, removed browsers and noVNC

## Usage
- Print out help page:

      docker run wittyfinch/ubuntu-vnc --help

- Run command with mapping to local port `5901` (vnc protocol):

      docker run -d -p 5901:5901 wittyfinch/ubuntu-vnc

- Change the default user and group within a container to your own with adding `--user $(id -u):$(id -g)`:

      docker run -d -p 5901:5901 --user $(id -u):$(id -g) wittyfinch/ubuntu-vnc

- If you want to get into the container use interactive mode `-it` and `bash`

      docker run -it -p 5901:5901 wittyfinch/ubuntu-vnc bash

- Build an image from scratch:

      docker build -t wittyfinch/ubuntu-vnc ubuntu-vnc

# Connect & Control
If the container is started like mentioned above, connect via one of these options:

* connect via __VNC viewer `localhost:5901`__, default password: `vncpassword`


## Hints

### 1) Extend a Image with your own software
The image runs as non-root user by default, so if you want to extend the image and install software, you have to switch back to the `root` user:

```bash
## Custom Dockerfile
FROM wittyfinch/ubuntu-vnc

# Switch to root user to install additional software
USER 0

## Install a mousepad
RUN apt-get install -y mousepad \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

## switch back to default user
USER 1000
```

### 2) Change User of running container

All container processes will be executed with user id `1000`. You can change the user id as follows:

#### 2.1) Using root (user id `0`)
Add the `--user` flag to your docker run command:

    docker run -it --user 0 -p 5901:5901 wittyfinch/ubuntu-vnc

#### 2.2) Using user and group id of host system
Add the `--user` flag to your docker run command:

    docker run -it -p 5901:5901 --user $(id -u):$(id -g) wittyfinch/ubuntu-vnc

### 3) Override VNC environment variables
The following VNC environment variables can be overwritten at the `docker run` phase to customize your desktop environment inside the container:
* `VNC_COL_DEPTH`, default: `24`
* `VNC_RESOLUTION`, default: `1280x1024`
* `VNC_PW`, default: `verylongandsecurepassword`

#### 3.1) Example: Override the VNC password
Simply overwrite the value of the environment variable `VNC_PW`. For example in the docker run command:

    docker run -it -p 5901:5901 -e VNC_PW=verylongandsecurepassword wittyfinch/ubuntu-vnc

#### 3.2) Example: Override the VNC resolution
Simply overwrite the value of the environment variable `VNC_RESOLUTION`. For example in the docker run command:

    docker run -it -p 5901:5901 -e VNC_RESOLUTION=800x600 wittyfinch/ubuntu-vnc

### 4) View only VNC
It's possible to prevent unwanted control via VNC. Therefore you can set the environment variable `VNC_VIEW_ONLY=true`. If set, the startup script will create a random password for the control connection and use the value of `VNC_PW` for view only connection over the VNC connection.

     docker run -it -p 5901:5901 -e VNC_VIEW_ONLY=true wittyfinch/ubuntu-vnc