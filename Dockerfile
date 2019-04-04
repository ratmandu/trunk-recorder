# docker build -t robotastic/trunk-recorder:latest .

FROM robotastic/docker-gnuradio:latest
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:myriadrf/drivers 
RUN apt-get update
RUN apt-get install -y limesuite liblimesuite-dev limesuite-udev limesuite-images soapysdr soapysdr-module-lms7 soapysdr-module-all


COPY . /src/trunk-recorder
RUN cd /src/trunk-recorder && cmake . && make -j8
RUN mkdir /app && cp /src/trunk-recorder/recorder /app
