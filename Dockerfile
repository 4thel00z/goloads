FROM alpine/git
COPY entrypoint-git.sh /entrypoint-git.sh
ENTRYPOINT [ "/entrypoint-git.sh"]

FROM metasploitframework/metasploit-framework
COPY --from=0 /repo /payloads
ENV TARGETS="/payloads/*"
COPY "entrypoint.py" "/entrypoint.py"
COPY "replacer.py" "/replacer.py"
COPY "main.template.go" "/main.template.go"
RUN ["python3", "/entrypoint.py"]
ENV TARGETS="/payloads/*.out"
RUN ["python3","/replacer.py", "/main.template.go"]


FROM golang:1.17
ENV GOPATH=/app
WORKDIR /go/src/app
COPY --from=1 /payloads/* /go/src/app/
COPY build.sh /go/src/app/build.sh
RUN "./build.sh"
COPY /go/src/app/*.exe /output/
