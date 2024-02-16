FROM phusion/passenger-full:latest
# Update Repo
RUN apt-get update

# Add the required Postgres libraries
RUN apt-get install -y libpq-dev

# nokogiri requirements
RUN apt-get install libxslt-dev libxml2-dev -y
# 
RUN apt-get install -y tzdata

RUN bash -lc 'rvm install "ruby-3.2.2"'
RUN bash -lc 'rvm --default use ruby-3.2.2'
RUN rm /etc/nginx/sites-enabled/default
RUN rm -f /etc/service/nginx/down
RUN rm -f /etc/service/redis/down
ADD config/nginx.conf /etc/nginx/sites-enabled/depot.conf

#START:app
USER app
RUN mkdir /home/app/depot
WORKDIR /home/app/depot

ENV RAILS_ENV=production
ENV BUNDLE_WITHOUT="development test"

COPY --chown=app:app Gemfile Gemfile.lock .
RUN bundle install
COPY --chown=app:app . .

RUN SECRET_KEY_BASE=`bin/rails secret` \
  bin/rails assets:precompile
#END:app

#START:init
USER root
CMD ["/sbin/my_init"]
#END:init
