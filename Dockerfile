FROM nginx

HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost/ || exit 1

ADD site /usr/share/nginx/html
COPY nginx/docs.conf /etc/nginx/conf.d/docs.conf
RUN find /usr/share/nginx/html -type d -exec chmod 755 {} \;
RUN find /usr/share/nginx/html -type f -exec chmod 644 {} \;
