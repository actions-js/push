FROM alpine:3.9

RUN apk --no-cache add openssl git curl openssh-client bash
    
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]