FROM innovanon/poobuntu-18.04:latest
# missing libcrypto.so.1.0.0 from libssl.1.0.0 ?
#FROM innovanon/poobuntu:latest
ARG MODE
MAINTAINER Innovations Anonymous <InnovAnon-Inc@protonmail.com>

LABEL version="1.0"                                                     \
      maintainer="Innovations Anonymous <InnovAnon-Inc@protonmail.com>" \
      about="docker doom server and client"                             \
      org.label-schema.build-date=$BUILD_DATE                           \
      org.label-schema.license="PDL (Public Domain License)"            \
      org.label-schema.name="docker-doom"                               \
      org.label-schema.url="InnovAnon-Inc.github.io/docker-doom"        \
      org.label-schema.vcs-ref=$VCS_REF                                 \
      org.label-schema.vcs-type="Git"                                   \
      org.label-schema.vcs-url="https://github.com/InnovAnon-Inc/docker-doom"

#RUN apt-fast install --yes --quiet libssl1.0.0 libsdl-image1.2 zandronum
#RUN apt-fast install doomsday-server doomsday
# TODO test last 2 pkgs
#    libsdl1.2debian libglew1.5
#RUN apt-fast install libfluidsynth1 fluid-soundfont-gm fluid-soundfont-gs

#ARG MODE
#ENV MODE
#ENV MODE=${MODE}
#ARG MODE

# Install required software
#RUN apt-fast install wget
RUN apt-fast update \
 && apt-fast install gnupg                                               \
 && pcurl http://debian.drdteam.org/drdteam.gpg | apt-key add -          \
 && apt-add-repository 'deb http://debian.drdteam.org stable multiverse' \
 && apt-fast update                                                      \
 && if [ "${MODE}" = server ] ; then  \
  apt-fast install zandronum-server ; \
elif   [ "${MODE}" = client ] ; then  \
  apt-fast install zandronum          \
    libgtk2.0-0 libglu1-mesa          \
    libcanberra-gtk-module          ; \
else exit 2                         ; \
fi \
 \
&&  useradd -ms /bin/bash zandronum   \
&&  if [ "${MODE}" = client ] ; then  \
      usermod -a -G audio zandronum   \
   && usermod -a -G video zandronum ; \
    fi \
 \
&& ./poobuntu-clean.sh

# Add start-up script
COPY ./bin/GeoIP.dat   /home/zandronum/GeoIP.dat
COPY ./bin/summon.bash /home/zandronum/bin/summon.sh

RUN chown -vR zandronum /home/zandronum/bin \
 && chmod -v +x         /home/zandronum/bin/summon.sh

USER zandronum
WORKDIR /home/zandronum
RUN mkdir -vp .config/zandronum

#CMD        ["/home/zandronum/bin/summon.sh", ${MODE}]
#ENTRYPOINT ["/home/zandronum/bin/summon.sh", ${MODE}]
CMD        /home/zandronum/bin/summon.sh ${MODE} zandronum
ENTRYPOINT /home/zandronum/bin/summon.sh ${MODE} zandronum
# TODO only expose the server
EXPOSE 10667/udp

