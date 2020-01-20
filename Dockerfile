FROM registry.access.redhat.com/ubi8/ubi:latest
LABEL io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"

ENV APP_ROOT=/opt/app-root/src

RUN mkdir -p ${APP_ROOT}
COPY ./s2i/bin/ /usr/libexec/s2i
RUN yum install -y java-11-openjdk.x86_64 java-11-openjdk-devel.x86_64 maven
ADD s2i-bin /usr/local/bin/s2i
RUN yum module install -y container-tools
RUN mkdir -p /.m2/repository

RUN chmod -R u+x ${APP_ROOT} && \
    chmod -R u+x /.m2/repository && \
    chgrp -R 0 ${APP_ROOT} && \
    chgrp -R 0 /.m2/repository && \
    chmod -R g=u ${APP_ROOT} /etc/passwd

ADD uid_entrypoint /usr/bin
WORKDIR ${APP_ROOT}
USER 1001

ENTRYPOINT [ "uid_entrypoint" ]
CMD ["/usr/libexec/s2i/usage"]