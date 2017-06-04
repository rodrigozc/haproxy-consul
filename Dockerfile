FROM haproxy:latest
MAINTAINER Rodrigo Zampieri Castilho <rodrigo.zampieri@gmail.com>

ENV CONSUL_VERSION "0.8.3"
ENV CONSUL_TEMPLATE_VERSION "0.18.5"
ENV CONSUL_SERVER "consul-server"
ENV CONSUL_INTERFACE "eth0"

RUN mkdir -p /opt/consul/data \
    && mkdir -p /opt/consul/config \
    && apt-get update \
    && apt-get install -y --no-install-recommends locales unzip wget \
    && echo "pt_BR.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen pt_BR.UTF-8 \
    && rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/* \
    # Consul Installation
    && wget --no-check-certificate https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip \
    && unzip consul_${CONSUL_VERSION}_linux_amd64.zip \
    && mv consul /usr/bin/consul \
    && chmod +x /usr/bin/consul \
    && rm consul_${CONSUL_VERSION}_linux_amd64.zip \
    # Consul Template Installation
    && wget --no-check-certificate https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
    && unzip consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip \
    && mv consul-template /usr/bin/consul-template \
    && chmod +x /usr/bin/consul-template \
    && rm consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip

ADD docker-entrypoint.sh docker-entrypoint.sh
ADD restart.bash restart.bash
ADD haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
