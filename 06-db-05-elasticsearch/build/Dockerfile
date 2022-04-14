FROM centos:7
MAINTAINER Nariman <nariman.wk@gmail.com>
#USER userelastic
EXPOSE 9200

RUN rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

#RUN yum install wget -y
#
#RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.0.0-linux-x86_64.tar.gz \
#&& wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.0.0-linux-x86_64.tar.gz.sha512 \
#&& shasum -a 512 -c elasticsearch-8.0.0-linux-x86_64.tar.gz.sha512 \
#&& tar -xzf elasticsearch-8.0.0-linux-x86_64.tar.gz \
#&& cd elasticsearch-8.0.0/

#ADD elasticsearch.yml /elasticsearch-8.0.0/config/

#RUN groupadd userelastic \
#    && useradd -g userelastic userelastic
    
CMD systemctl enable --now elasticsearch