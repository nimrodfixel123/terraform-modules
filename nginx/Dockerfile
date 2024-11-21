FROM nginx:latest

# Create required directories
RUN mkdir -p /var/cache/nginx \
    /var/run \
    /var/log/nginx \
    /etc/nginx/certs \
    /var/cache/nginx/client_temp \
    /var/cache/nginx/proxy_temp \
    /var/cache/nginx/fastcgi_temp \
    /var/cache/nginx/uwsgi_temp \
    /var/cache/nginx/scgi_temp

COPY nginx.conf /etc/nginx/nginx.conf
COPY certs/ /etc/nginx/certs/

RUN chmod 644 /etc/nginx/certs/server.crt && \
    chmod 644 /etc/nginx/certs/server.key

EXPOSE 443