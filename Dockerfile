FROM alpine:3.8
MAINTAINER rruizveve@gmail.com

ENV APP_HOME="/app" \
    GEMS="/usr/local/bundle" \
    ENTRY_POINT_DIR="docker-entrypoint-init.d" \
    RUBY_PACKAGES="ruby ruby-dev ruby-rdoc ruby-irb ruby-io-console ruby-json yaml ruby-rake ruby-bigdecimal ruby-etc ruby-webrick nodejs-npm curl jq" \
    DEV_PACKAGES="zlib-dev libxml2-dev libffi-dev libxslt-dev postgresql-dev tzdata yaml-dev libstdc++ bash ca-certificates imagemagick" \
    BUILD_PACKAGES="build-base libressl-dev libc-dev linux-headers git"

RUN apk update && apk --update add $DEV_PACKAGES $RUBY_PACKAGES

RUN npm install apidoc -g

RUN mkdir -p /aws && \
    apk -Uuv add groff less python py-pip && \
    pip install awscli && \
    apk --purge -v del py-pip && \
    rm /var/cache/apk/*

ADD Gemfile $GEMS/
ADD Gemfile.lock $GEMS/
WORKDIR $GEMS

RUN apk --update add --no-cache --virtual build-dependencies $BUILD_PACKAGES && \
    gem install bundler && \
    bundle install --jobs=4 && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/*

RUN mkdir $APP_HOME
WORKDIR $APP_HOME
ADD . $APP_HOME
EXPOSE 3000

CMD ["sudo", "rm", "tmp/pids/server.pid"]
CMD ["rails", "s", "-p", "3000", "-b", "0.0.0.0"]
