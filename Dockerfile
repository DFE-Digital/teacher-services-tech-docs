FROM nginx:1.23.3

COPY ./build/ /usr/share/nginx/html
