FROM nginx:1.29.3-alpine-slim

COPY nginx.conf /etc/nginx/nginx.conf

COPY ./build/ /usr/share/nginx/html
