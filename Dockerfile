#FROM innovanon/poobuntu-18.04:latest
# missing libcrypto.so.1.0.0 from libssl.1.0.0 ?
FROM innovanon/poobuntu:latest
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

RUN if [ "${MODE}" = server ] ; then      \
      apt-fast install doomsday-server  ; \
    elif   [ "${MODE}" = client ] ; then  \
      apt-fast install doomsday           \
        libgtk2.0-0 libglu1-mesa          \
        libsdl1.2debian libglew2.1      ; \
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
RUN mkdir -vp .config/doomsday

#CMD        /home/zandronum/bin/summon.sh ${MODE}
ENTRYPOINT /home/zandronum/bin/summon.sh ${MODE} doomsday
# TODO only expose the server
EXPOSE 10667/udp

