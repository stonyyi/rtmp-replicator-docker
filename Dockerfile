FROM       cine/nginx-rtmp-mediatools-docker

MAINTAINER Jeffrey Wescott <jeffrey@cine.io>

# make sure the ffmpeg log file exists
RUN touch /var/log/ffmpeg.log

# copy our service
COPY service /service

# install npm depdendencies
WORKDIR /service/nginx_reloader
RUN npm install --production

WORKDIR /service

# start nginx
CMD ["/service/bin/run"]

# configuration
#rtmp
EXPOSE 1935
#stats
# EXPOSE 80
