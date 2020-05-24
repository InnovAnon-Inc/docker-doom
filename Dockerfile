FROM innovanon/poobuntu:latest
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

# Install required software
#RUN apt-fast install wget
#RUN wget -qO- http://debian.drdteam.org/drdteam.gpg | apt-key add -
#RUN apt-add-repository 'deb http://debian.drdteam.org stable multiverse'
#RUN apt-fast update
#ARG SERVER
#ENV SERVER ${SERVER}
ARG MODE
ENV MODE ${MODE}
#RUN apt-fast install --yes --quiet libssl1.0.0 libsdl-image1.2 zandronum
#RUN apt-fast install doomsday-server doomsday

RUN dpkg --add-architecture i386
RUN apt-fast update
RUN apt-fast install libc6-i386 libstdc++6:i386
RUN pcurl http://downloads.zdaemon.org/zserv11012_linux26.tgz | tar xzf -

#RUN if [ "${MODE}" = server ] ; then  \
#  apt-fast install zandronum-server ; \
#elif   [ "${MODE}" = client ] ; then  \
#  apt-fast install zandronum          \
#    libgtk2.0-0 libglu1-mesa        ; \
#else exit 2                         ; \
#fi

#RUN [ ${MODE} != client ] || apt-fast install --yes libgtk2.0-0 libglu1-mesa
#libsdl1.2debian libglew1.5

#RUN [ ${MODE} = server ] || [ ${MODE} = client ]

# Create a non-privileged user
RUN useradd -ms /bin/bash zandronum
RUN [ "${MODE}" != client ] || usermod -a -G audio zandronum
RUN [ "${MODE}" != client ] || usermod -a -G video zandronum

RUN mv -v  zserv110_bin/zserv zserv110_bin/zdaemon.wad /home/zandronum/
RUN rm -rf zserv110_bin

# brutalize
#RUN mkdir -vp /home/zandronum/.config/zandronum
#RUN wget -O   /home/zandronum/.config/zandronum/project_brutality.pk3 https://github.com/pa1nki113r/Project_Brutality/archive/master.zip

RUN ./poobuntu-clean.sh

# Add start-up script
#COPY ./bin/GeoIP.dat   /home/zandronum/GeoIP.dat
COPY ./bin/summon.bash /home/zandronum/bin/summon.sh

RUN chown -vR zandronum /home/zandronum/bin
RUN chmod -v +x         /home/zandronum/bin/summon.sh

USER zandronum
WORKDIR /home/zandronum

#CMD        ["/home/zandronum/bin/summon.sh", ${MODE}]
#ENTRYPOINT ["/home/zandronum/bin/summon.sh", ${MODE}]
#CMD        /home/zandronum/bin/summon.sh
#ENTRYPOINT ["/home/zandronum/bin/summon.sh"]
ENTRYPOINT "/home/zandronum/bin/summon.sh" ${MODE}
EXPOSE 10666/udp

