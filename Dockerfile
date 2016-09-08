FROM ntxcode/ubuntu-base:14.04
MAINTAINER Nathan Ribeiro, ntxdev <nathan@ntxdev.com.br>

# Install nginx
RUN \
  apt-get update -yq && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends nginx && \
  mkdir -p /var/www

# Copy application builds to their expected location
COPY ./zup-landingpage /var/www/zup-landing
COPY ./zup-painel /var/www/zup-painel
COPY ./zup-web-angular /var/www/zup-web-cidadao

COPY ./entrypoint.sh /

COPY ./nginx.conf /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/default
RUN chown -R nobody. /var/www

ENTRYPOINT ["/entrypoint.sh"]

CMD ["nginx"]
