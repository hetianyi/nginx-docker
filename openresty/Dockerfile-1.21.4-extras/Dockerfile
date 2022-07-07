FROM alpine:3.16

MAINTAINER "hehety<hehety@outlook.com>"

ARG NGINX_VERSION=${NGINX_VERSION:-1.21.4}
ARG NGINX_SUB_VERSION=${NGINX_VERSION}.1

ENV NGINX_VERSION $NGINX_VERSION
ENV TZ "Asia/Shanghai"

ADD modules.tar.gz /tmp/modules

RUN sed -i "s@https://dl-cdn.alpinelinux.org/@https://repo.huaweicloud.com/@g" /etc/apk/repositories && \
	apk add --no-cache --virtual .build-deps \
        libxslt-dev \
        libxml2 \
        gd-dev \
        geoip-dev \
        libatomic_ops-dev \
        pcre-dev \
        zlib-dev \
        build-base \
        libaio-dev \
        linux-headers \
        openssl-dev \
        libmaxminddb-dev \
        openldap-dev && \
addgroup -g 101 -S nginx && \
adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx && \
cd /tmp && \
wget https://openresty.org/download/openresty-${NGINX_SUB_VERSION}.tar.gz && \
tar -xzf openresty-${NGINX_SUB_VERSION}.tar.gz && \
cd openresty-${NGINX_SUB_VERSION} && \
mv /tmp/modules ./ && \
./configure \
--prefix=/usr/share \
--sbin-path=/usr/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/run/nginx.lock \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--user=nginx \
--with-debug \
--with-http_iconv_module \
--with-select_module \
--with-poll_module \
--with-threads \
--with-file-aio \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_xslt_module \
--with-http_image_filter_module \
--with-http_geoip_module \
--with-http_sub_module \
--with-http_dav_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_auth_request_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_degradation_module \
--with-http_slice_module \
--with-http_stub_status_module \
--with-mail \
--with-mail_ssl_module \
--with-stream \
--with-stream_ssl_module \
--with-stream_realip_module \
--with-stream_geoip_module \
--with-stream_ssl_preread_module \
--with-compat \
--with-pcre \
--with-libatomic \
--add-module=modules/nginx-auth-ldap \
--add-module=modules/nginx-rtmp-module \
--add-module=modules/nginx-upsync-module \
--add-module=modules/ngx_http_geoip2_module && \
make -j8 && make install && \
rm -rf /tmp/* && \
mkdir -p /var/run && \
mkdir -p /var/log/nginx && \
apk del .build-deps && \
apk add libxslt libxml2 gd geoip libatomic_ops pcre zlib openssl libgcc openldap ffmpeg libmaxminddb && \
apk add --no-cache tzdata && \
ln -sf /dev/stdout /var/log/nginx/access.log && \
ln -sf /dev/stderr /var/log/nginx/error.log

# expose port 80 443
EXPOSE 80
EXPOSE 443

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]