FROM localhost:5000/nginx:$NGINX_VERSION
ARG NGINX_VERSION
COPY index.html /usr/share/nginx/html
