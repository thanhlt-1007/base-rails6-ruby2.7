FROM khuonghb/ubuntu16.04_ruby2.7.1:latest
MAINTAINER KhuongNT

USER deploy
RUN sudo chown -R deploy:deploy /usr/local/
RUN sudo chown -R deploy:deploy /home/deploy/
RUN mkdir /home/deploy/base-rails6-ruby2.7
WORKDIR /home/deploy/base-rails6-ruby2.7
ADD . /home/deploy/base-rails6-ruby2.7
RUN sudo cp config/database.yml.ci config/database.yml
RUN sudo cp .env.example .env
RUN /bin/bash -l -c "bundle install"
RUN /bin/bash -l -c "sudo yarn install --check-files"
