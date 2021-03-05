FROM ruby:2.7.2
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq \
    && apt-get install -y nodejs yarn \
    && mkdir /records-management-gamefiction

# Nginx
RUN rm -f /etc/nginx/conf.d/*
ADD nginx.conf /etc/nginx/conf.d/records-management-gamefiction.conf

# Rails App
WORKDIR /records-management-gamefiction
ADD Gemfile /records-management-gamefiction/Gemfile
ADD Gemfile.lock /records-management-gamefiction/Gemfile.lock
RUN bundle install
ADD . /records-management-gamefiction
RUN mkdir /records-management-gamefiction/tmp/sockets

# Start Server
CMD bundle exec puma -d && \
    /usr/sbin/nginx -g 'daemon off;' -c /etc/nginx/nginx.conf
