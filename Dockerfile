FROM php:8.2-fpm-alpine
LABEL MAINTAINER="ikiwi ikiwicc@gmail.com"

# 设置为中文，时区为北京时间
ENV LANG=zh_CN.UTF-8
ENV TZ "Asia/Shanghai"
ENV TERM xterm

# 默认关闭opcode
ENV OPCODE 0

# alpine源替换为腾讯源，更新软件
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.cloud.tencent.com/g' /etc/apk/repositories
RUN apk update
RUN apk add --update --no-cache bash nano curl wget tzdata nginx su-exec

# 安装gd mysqli pdo_mysql扩展
# RUN docker-php-ext-install mysqli pdo_mysql

# 复制目录到镜像
COPY ./source /app
COPY ./nginx /etc/nginx

# 为app和nginx目录脚本添加权限
RUN chmod 777 -R /app
RUN chmod 755 -R /etc/nginx

# 复制php.ini
# RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY ./php.ini $PHP_INI_DIR/php.ini

# 复制entrypoint.sh脚本到容器中的entrypoint.sh路径
COPY entrypoint.sh /entrypoint.sh

# 为entrypoint.sh脚本添加可执行权限
RUN ["chmod", "+x", "/entrypoint.sh"]

# 设置工作目录
WORKDIR /app

EXPOSE 80

# 设置容器启动时的入口点为entrypoint.sh脚本
ENTRYPOINT ["/entrypoint.sh"]