FROM registry.access.redhat.com/ubi8/ubi:latest

ENV APP_ROOT=/opt/app-root/src
ENV HOME=/opt/app-root/src
WORKDIR ${APP_ROOT}

RUN mkdir -p ${APP_ROOT}
COPY ./s2i/bin/ /usr/libexec/s2i
RUN yum install -y java-11-openjdk.x86_64 java-11-openjdk-devel.x86_64 maven
RUN mkdir -p ${APP_ROOT}/.m2/repository

RUN chmod -R u+x ${APP_ROOT} && \
    chgrp -R 0 ${APP_ROOT} && \
    chmod -R g=u ${APP_ROOT} /etc/passwd

ADD uid_entrypoint /usr/bin
ADD settings.xml /usr/share/maven/conf
USER 1001

ENTRYPOINT [ "uid_entrypoint" ]
CMD ["/usr/libexec/s2i/usage"]