FROM nginx/nginx-unprivileged:1.30.7-alpine3.24

USER root
RUN apk upgrade --no-cache
USER 101

COPY nginx.conf /etc/nginx/nginx.conf

COPY ./build/ /usr/share/nginx/html
