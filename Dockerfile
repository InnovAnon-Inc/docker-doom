FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive 

# Disable Upstart
RUN dpkg-divert --local --rename --add /sbin/initctl \
  && ln -sf /bin/true /sbin/initctl \
  && ln -sf /bin/false /usr/sbin/policy-rc.d

# Install required software
RUN apt-get update --yes \
  && apt-get upgrade --yes \
  && apt-get install --yes dialog apt-utils software-properties-common wget \
  && apt-add-repository 'deb http://debian.drdteam.org stable multiverse' \
  &&  wget -O - http://debian.drdteam.org/drdteam.gpg | apt-key add - \
  && apt-get update --yes \
  && apt-get install --yes --quiet libsdl-image1.2 zandronum

# Create a non-privileged user
RUN useradd -ms /bin/bash zandronum

# Add start-up script
COPY ./bin/GeoIP.dat /home/zandronum/GeoIP.dat
COPY ./bin/summon.bash /home/zandronum/bin/summon.sh

RUN chown -R zandronum /home/zandronum/bin \
  && chmod +x /home/zandronum/bin/summon.sh

USER zandronum
WORKDIR /home/zandronum

CMD ["/home/zandronum/bin/summon.sh"]
ENTRYPOINT ["/home/zandronum/bin/summon.sh"]
EXPOSE 10666
