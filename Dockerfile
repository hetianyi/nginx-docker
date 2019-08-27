# build nginx docker images with stream module
FROM alpine
MAINTAINER "hehety<hehety@outlook.com>"

ENV NGINX_VERSION 1.15.8

RUN apk add --no-cache --virtual .build-deps \
        libxslt-dev \
        libxml2 \
        gd-dev \
        geoip-dev \
        libatomic_ops-dev \
        pcre-dev \
        zlib-dev \
        build-base \
        libaio-dev \
        openssl-dev && \
addgroup -g 101 -S nginx && \
adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx && \
cd /tmp && \
wget http://nginx.org/download/nginx-1.15.8.tar.gz && \
tar -xzf nginx-1.15.8.tar.gz && \
cd nginx-1.15.8 && \
./configure --prefix=/usr/share/nginx \
--sbin-path=/usr/bin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/run/nginx.lock \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--user=nginx \
--with-select_module \
--with-poll_module \
--with-threads \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_xslt_module \
--with-http_image_filter_module \
--with-http_geoip_module \
--with-http_sub_module \
--with-http_dav_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_auth_request_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_degradation_module \
--with-http_slice_module \
--with-http_stub_status_module \
--with-stream \
--with-stream_ssl_module \
--with-stream_realip_module \
--with-stream_geoip_module \
--with-stream_ssl_preread_module \
--with-compat \
--with-libatomic \
--with-debug && \
make && make install && \
cp -rf html /usr/share/nginx && \
rm -rf /tmp/* && \
mkdir -p /var/run && \
mkdir -p /var/log/nginx && \
apk del .build-deps && \
apk add libxslt libxml2 gd geoip libatomic_ops pcre zlib openssl





ADD nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]