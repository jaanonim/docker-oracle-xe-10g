FROM debian

# STEP 1: Set environment variables
ENV ORACLE_HOME=/usr/lib/oracle/xe/app/oracle/product/10.2.0/server 
ENV LD_LIBRARY_PATH=$ORACLE_HOME/lib
ENV PATH=$ORACLE_HOME/bin:$PATH
ENV ORACLE_SID=XE
ENV NLS_LANG=AMERICAN_AMERICA.WE8MSWIN1252

RUN echo 'export ORACLE_HOME=/usr/lib/oracle/xe/app/oracle/product/10.2.0/server' >> /etc/bash.bashrc && \
    echo 'export LD_LIBRARY_PATH=$ORACLE_HOME/lib' >> /etc/bash.bashrc && \
    echo 'export PATH=$ORACLE_HOME/bin:$PATH' >> /etc/bash.bashrc && \
    echo 'export ORACLE_SID=XE' >> /etc/bash.bashrc && \
    echo 'export NLS_LANG=AMERICAN_AMERICA.WE8MSWIN1252' >> /etc/bash.bashrc


# STEP 2: Install dependences
RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install -y \ 
    bc:i386 \
    libaio1:i386 \
    libc6-i386 \
    net-tools \
    wget && \
    apt-get clean

# STEP 3: Get apex installer
#### Download installer ####
#RUN wget --no-check-certificate https://oss.oracle.com/debian/dists/unstable/non-free/binary-i386/oracle-xe_10.2.0.1-1.1_i386.deb -O ./installer.deb
#### Copy installer ####
COPY ./installer.deb ./installer.deb

# STEP 4: Install apex from installer
RUN dpkg -i installer.deb && \
    rm installer.deb

# STEP 5: Some config and stuff
RUN sed -i 's/51200K/4096K/' /usr/lib/oracle/xe/app/oracle/product/10.2.0/server/config/scripts/cloneDBCreation.sql && \        
    printf 8080\\n1521\\noracle\\noracle\\ny\\n | /etc/init.d/oracle-xe configure

# STEP 6: Startup script
COPY ./startdb /bin/startdb	
RUN chmod +x /bin/startdb	

# 8080 - web admin
# 1521 - database
EXPOSE 8080 1521 

CMD startdb && tail -f /usr/lib/oracle/xe/app/oracle/admin/XE/bdump/alert_XE.log
