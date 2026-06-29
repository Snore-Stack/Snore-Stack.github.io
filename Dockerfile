# cwebp
FROM alpine:3.23.5

RUN apk add --no-cache wget tar inotify-tools
RUN mkdir -p /tmp
WORKDIR /tmp
RUN wget https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.3.2-linux-x86-64.tar.gz
RUN tar -xvf libwebp-1.3.2-linux-x86-64.tar.gz
COPY scripts/webp-convert.sh .
RUN chmod +x webp-convert.sh
ENV PATH=$PATH:/tmp/libwebp-1.3.2-linux-x86-64/bin
RUN mkdir -p /assets
WORKDIR /assets

CMD ["/tmp/webp-convert.sh"]
