# Container image that runs your code
FROM metasploitframework/metasploit-framework
ENV TARGETS="/github/workspace/*"
COPY "entrypoint.py" "/entrypoint.py"
COPY "replacer.py" "/replacer.py"
COPY "main.template.go" "/main.template.go"
RUN ["python3", "/entrypoint.py"]
ENV TARGETS="/github/workspace/*.out"
RUN ["python3","/replacer.py", "/main.template.go"]


FROM golang:1.17
ENV GOPATH=/app
WORKDIR /go/src/app
COPY --from=0 /github/workspace/* /go/src/app/
COPY build.sh /go/src/app/build.sh
RUN "./build.sh"
COPY /go/src/app/*.exe /output/
