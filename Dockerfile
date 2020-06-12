FROM centos:7

ARG USER_ID=2000
ARG GROUP_ID=2000


ENV USER="admin"
ENV PASSWORD="admin123"
ENV PASV_ADDRESS="127.0.0.1"
ENV MIN_PORT=50000
ENV MAX_PORT=52000
ENV DIRECTORY=/home/ftpuser

RUN yum update  -y && yum clean all
RUN yum install -y \
    vsftpd \
    db4-utils \
    db4 \
    net-tools vim \
    iproute && yum clean all;\
    useradd -u ${USER_ID} -s /sbin/nologin   ftpuser; \
    rm -rf /etc/vsftpd/*

ADD files/ /etc/vsftpd/
COPY vsftpd.vu /etc/pam.d/
COPY run-vsftpd.sh /usr/sbin/
COPY create-user.sh /usr/sbin/

RUN chmod +x /usr/sbin/run-vsftpd.sh

VOLUME /home/ftpuser
VOLUME /etc/vsftpd
EXPOSE 21

CMD ["/usr/sbin/run-vsftpd.sh"]

