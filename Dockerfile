# Container image that runs your code
FROM metasploitframework/metasploit-framework
ENV TARGETS="/payloads/*"
COPY "entrypoint.py" "/entrypoint.py"
COPY "replacer.py" "/replacer.py"
COPY "main.template.go" "/main.template.go"
COPY *.payload /payloads/
RUN ["python3", "/entrypoint.py"]
ENV TARGETS="/payloads/*.out"
RUN ["python3","/replacer.py", "/main.template.go"]


FROM golang:1.17
ENV GOPATH=/app
WORKDIR /go/src/app
COPY --from=0 /payloads/* /go/src/app/
COPY build.sh /go/src/app/build.sh

RUN "./build.sh"
