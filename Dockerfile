FROM seffeng/alpine:3.16

LABEL author="zxf <seffeng@live.com>"

ARG BASE_DIR="/opt/websrv"
ARG NGINX_VERSION="openresty-1.17.8.2"
ARG PCRE_VERSION_NUMBER="8.45"
ARG ZLIB_VERSION="zlib-1.2.13"

ENV PCRE_VERSION="pcre-${PCRE_VERSION_NUMBER}"\
 CONFIG_DIR="${BASE_DIR}/config"\
 INSTALL_DIR="${BASE_DIR}/program/openresty"\
 BASE_PACKAGE="gcc g++ make postgresql-dev file"\
 EXTEND="libgcc libpq perl"\
 WWWROOT_DIR="${BASE_DIR}/data/wwwroot"

ENV NGINX_URL="https://openresty.org/download/${NGINX_VERSION}.tar.gz"\
 PCRE_URL="https://udomain.dl.sourceforge.net/project/pcre/pcre/${PCRE_VERSION_NUMBER}/${PCRE_VERSION}.tar.gz"\
 ZLIB_URL="https://zlib.net/${ZLIB_VERSION}.tar.gz"\
 CONFIGURE="./configure\
 --user=www\
 --group=wwww\
 --prefix=${INSTALL_DIR}\
 --conf-path=${CONFIG_DIR}/nginx/nginx.conf\
 --error-log-path=${BASE_DIR}/logs/error.log\
 --http-log-path=${BASE_DIR}/logs/access.log\
 --lock-path=${BASE_DIR}/tmp/nginx.lock\
 --pid-path=${BASE_DIR}/tmp/nginx.pid\
 --sbin-path=${INSTALL_DIR}/sbin/nginx\
 --with-http_addition_module\
 --with-http_dav_module\
 --with-http_degradation_module\
 --with-http_flv_module\
 --with-http_gzip_static_module\
 --with-http_iconv_module\
 --with-http_mp4_module\
 --with-http_postgres_module\
 --with-http_random_index_module\
 --with-http_realip_module\
 --with-http_secure_link_module\
 --with-http_slice_module\
 --with-http_ssl_module\
 --with-http_stub_status_module\
 --with-http_sub_module\
 --with-http_v2_module\
 --with-luajit\
 --with-mail\
 --with-mail_ssl_module\
 --with-pcre-jit\
 --with-pcre=/tmp/${PCRE_VERSION}\
 --with-stream_realip_module\
 --with-stream_ssl_module\
 --with-zlib=/tmp/${ZLIB_VERSION}"

WORKDIR /tmp
COPY    conf ./conf

RUN \
 ############################################################
 # apk add
 ############################################################
 apk update && apk add --no-cache ${BASE_PACKAGE} ${EXTEND} &&\
 mkdir -p ${WWWROOT_DIR} ${BASE_DIR}/logs ${BASE_DIR}/tmp ${CONFIG_DIR}/nginx/certs.d &&\
 addgroup wwww && adduser -H -D -s /sbin/nologin -G wwww www &&\
 ############################################################
 # download files
 ############################################################
 wget ${NGINX_URL} &&\
 wget ${PCRE_URL} &&\
 wget ${ZLIB_URL} &&\
 tar -zxf ${NGINX_VERSION}.tar.gz &&\
 tar -zxf ${PCRE_VERSION}.tar.gz &&\
 tar -zxf ${ZLIB_VERSION}.tar.gz &&\
 ############################################################
 # install nginx
 ############################################################
 cd /tmp/${NGINX_VERSION} &&\
 ${CONFIGURE} &&\
 make && make install &&\
 ln -s ${INSTALL_DIR}/sbin/nginx /usr/bin/nginx &&\
 cp -Rf /tmp/conf/* ${CONFIG_DIR}/nginx &&\
 ############################################################
 apk del ${BASE_PACKAGE} &&\
 rm -rf /var/cache/apk/* &&\
 rm -rf /tmp/*

VOLUME ["${BASE_DIR}/logs"]

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]