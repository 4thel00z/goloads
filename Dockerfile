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
WORKDIR /app
COPY --from=0 /payloads/* /app/
COPY go.mod /app
COPY build.sh /app/build.sh

RUN "./build.sh"
