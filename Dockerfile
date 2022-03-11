FROM openjdk:11 AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends wget && rm -rf /var/lib/apt/lists/*

ARG JAVA_DOWNLOAD_CHECKSUM=3784cfc4670f0d4c5482604c7c513beb1a92b005f569df9bf100e8bef6610f2e
RUN cd /opt; wget --no-check-certificate https://download.java.net/java/ga/jdk11/openjdk-11_linux-x64_bin.tar.gz && echo "${JAVA_DOWNLOAD_CHECKSUM}  openjdk-11_linux-x64_bin.tar.gz"  | sha256sum -c && tar zxf openjdk-11_linux-x64_bin.tar.gz && rm -f openjdk-11_linux-x64_bin.tar.gz

ENV JAVA_HOME=/opt/jdk-11
ENV PATH="$PATH:$JAVA_HOME/bin"

COPY target/docker-spring-demo.jar build/docker-spring-demo.jar

RUN jdeps --ignore-missing-deps -q --multi-release 11 --print-module-deps build/docker-spring-demo.jar > jre-deps.info
RUN jlink --compress 2 --no-header-files --no-man-pages --output custom-jre --add-modules $(cat jre-deps.info)

ENV JAVA_HOME=custom-jre
ENV PATH="$PATH:$JAVA_HOME/bin"

FROM openjdk:11
COPY --from=builder /app/custom-jre custom-jre
COPY --from=builder /app/build/docker-spring-demo.jar docker-spring-demo.jar
EXPOSE 8085
ENTRYPOINT [ "java","-jar","docker-spring-demo.jar" ]