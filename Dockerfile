FROM ruby:2.7.2
RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs && \
    apt-get install -y nginx
# Nginx
ADD nginx.conf /etc/nginx/sites-available/app.conf
RUN rm -f /etc/nginx/sites-enabled/default && \
    ln -s /etc/nginx/sites-available/app.conf /etc/nginx/sites-enabled/app.conf

# Rails App
RUN mkdir /records-management-gamefiction
WORKDIR /records-management-gamefiction
ADD Gemfile /records-management-gamefiction/Gemfile
ADD Gemfile.lock /records-management-gamefiction/Gemfile.lock
RUN bundle install
ADD . /records-management-gamefiction
RUN mkdir /records-management-gamefiction/tmp/sockets

# Start Server
CMD bundle exec puma -d && \
    /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf
