FROM nginxinc/nginx-unprivileged:1.29.5-alpine3.23-slim

COPY nginx.conf /etc/nginx/nginx.conf

COPY ./build/ /usr/share/nginx/html
