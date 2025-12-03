FROM nginxinc/nginx-unprivileged:1.29.2-alpine3.22

COPY nginx.conf /etc/nginx/nginx.conf

COPY ./build/ /usr/share/nginx/html
