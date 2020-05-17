#FROM ubuntu:16.04
FROM poobuntu-16.04:latest
MAINTAINER Innovations Anonymous <InnovAnon-Inc@protonmail.com>

# Install required software
RUN apt-fast install -y wget
RUN wget -O - http://debian.drdteam.org/drdteam.gpg | apt-key add -
RUN apt-add-repository 'deb http://debian.drdteam.org stable multiverse'
RUN apt-fast update
ARG SERVER
ENV SERVER ${SERVER}
#RUN apt-fast install --yes --quiet libssl1.0.0 libsdl-image1.2 zandronum
RUN apt-fast install --yes --quiet doomsday-server doomsday

ARG MODE
ENV MODE ${MODE}
#RUN [ ${MODE} != client ] || apt-fast install --yes libgtk2.0-0 libglu1-mesa
#libsdl1.2debian libglew1.5

RUN ./poobuntu-clean.sh
RUN rm -v poobuntu-clean.sh

# Create a non-privileged user
RUN useradd -ms /bin/bash zandronum

# brutalize
RUN mkdir -vp /home/zandronum/.config/${SERVER}
RUN wget -O   /home/zandronum/.config/${SERVER}/project_brutality.pk3 https://github.com/pa1nki113r/Project_Brutality/archive/master.zip

# Add start-up script
COPY ./bin/GeoIP.dat   /home/zandronum/GeoIP.dat
COPY ./bin/summon.bash /home/zandronum/bin/summon.sh

RUN chown -vR zandronum /home/zandronum/bin
RUN chmod -v +x         /home/zandronum/bin/summon.sh

USER zandronum
WORKDIR /home/zandronum

#CMD        ["/home/zandronum/bin/summon.sh", ${MODE}]
#ENTRYPOINT ["/home/zandronum/bin/summon.sh", ${MODE}]
CMD        /home/zandronum/bin/summon.sh ${MODE} ${SERVER}
ENTRYPOINT /home/zandronum/bin/summon.sh ${MODE} ${SERVER}
EXPOSE 10666
