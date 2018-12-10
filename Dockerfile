FROM ubuntu:18.04

ENV DISPLAY :1
ENV VNC_PORT 5901
EXPOSE $VNC_PORT

### Envrionment config
ENV HOME=/headless \
    TERM=xterm \
    STARTUPDIR=/dockerstartup \
    INST_SCRIPTS=/headless/install \
    DEBIAN_FRONTEND=noninteractive \
    VNC_COL_DEPTH=24 \
    VNC_RESOLUTION=1280x1024 \
    VNC_PW=vncpassword \
    VNC_VIEW_ONLY=false
WORKDIR $HOME

### Add install scripts for further steps
ADD ./src/install/ $INST_SCRIPTS/
RUN find $INST_SCRIPTS -name '*.sh' -exec chmod a+x {} + \
  && apt-get update

### Install essential packages
RUN $INST_SCRIPTS/tools.sh
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

### Install custom fonts
RUN $INST_SCRIPTS/install_custom_fonts.sh

### Install xvnc-server
RUN $INST_SCRIPTS/tigervnc.sh

### Install xfce UI
RUN $INST_SCRIPTS/xfce_ui.sh
ADD ./src/xfce/ $HOME/

### configure startup
RUN $INST_SCRIPTS/libnss_wrapper.sh
ADD ./src/scripts $STARTUPDIR
RUN $INST_SCRIPTS/set_user_permission.sh $STARTUPDIR $HOME \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

USER 1000

ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--wait"]