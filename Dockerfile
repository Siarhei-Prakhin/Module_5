ARG NGINX_VERSION
FROM localhost:5000/nginx:$NGINX_VERSION
COPY index.html /usr/share/nginx/html
