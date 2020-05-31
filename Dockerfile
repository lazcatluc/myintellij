FROM ubuntu:18.04

RUN rm /var/cache/apt/pkgcache.bin
RUN rm /var/cache/apt/srcpkgcache.bin
RUN apt-get update
RUN apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -y
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -	
RUN add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
RUN apt-get install docker-ce docker-ce-cli containerd.io -y
RUN apt-get update   
RUN apt-get install firefox -y
RUN apt-get install libgl1-mesa-glx -y
RUN apt-get install wget -y
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt-get install fonts-liberation -y
RUN apt-get install libappindicator3-1 -y
RUN apt-get install libnspr4 -y
RUN apt-get install libnss3 -y
RUN apt-get install libxss1 -y
RUN apt-get install xdg-utils -y
RUN apt-get install libgbm1 -y
RUN dpkg -i google-chrome-stable_current_amd64.deb
RUN wget https://chromedriver.storage.googleapis.com/83.0.4103.39/chromedriver_linux64.zip
RUN apt-get install unzip -y
RUN unzip chromedriver_linux64.zip
RUN ln -s /chromedriver /usr/bin/chromedriver
RUN chromedriver -v

RUN apt-get install git -y
RUN git config --global user.name "Catalin Lazar"
RUN git config --global user.email "lazcatluc@gmail.com"
RUN git config --global push.default simple

RUN apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - 
RUN apt-get install -y nodejs

RUN wget https://download.java.net/java/GA/jdk14.0.1/664493ef4a6946b186ff29eb326336a2/7/GPL/openjdk-14.0.1_linux-x64_bin.tar.gz
RUN mkdir /usr/share/java
RUN tar -xzf openjdk-14.0.1_linux-x64_bin.tar.gz -C /usr/share/java
ENV JAVA_HOME /usr/share/java/jdk-14.0.1
RUN ln -s /usr/share/java/jdk-14.0.1/bin/java /usr/bin/java
RUN rm openjdk-14.0.1_linux-x64_bin.tar.gz
RUN java -version

ARG MAVEN_VERSION=3.6.3
ARG USER_HOME_DIR="/root"
ARG BASE_URL=https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn  
RUN mvn -version

RUN apt-get update && apt-get install -y vim && apt-get install -y libgtk2.0-0 libcanberra-gtk-module
RUN echo 'Installing Intellij'
RUN wget https://download.jetbrains.com/idea/ideaIU-2020.1.1-no-jbr.tar.gz
RUN tar -xf ideaIU-2020.1.1-no-jbr.tar.gz -C /opt
RUN rm ideaIU-2020.1.1-no-jbr.tar.gz
ADD .IntelliJIdea2016.1 /root/.IntelliJIdea2016.1
RUN sed -i 's/Xms128m/Xms2048m/g' /opt/$(ls /opt | grep idea)/bin/idea64.vmoptions
RUN sed -i 's/Xmx750m/Xmx2048m/g' /opt/$(ls /opt | grep idea)/bin/idea64.vmoptions
RUN cat /opt/$(ls /opt | grep idea)/bin/idea64.vmoptions
ADD .ssh /root/.ssh
RUN chmod 600 /root/.ssh/id_rsa
ENV IDEA_JDK /usr/share/java/jdk-14.0.1

RUN rm -rf /tmp/*

CMD dockerd & /opt/idea*/bin/idea.sh
