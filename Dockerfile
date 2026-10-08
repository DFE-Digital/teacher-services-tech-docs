FROM nginxinc/nginx-unprivileged:1.29.5-alpine3.23-slim

USER root
RUN apk upgrade --no-cache
USER 101

COPY nginx.conf /etc/nginx/nginx.conf

COPY ./build/ /usr/share/nginx/html
