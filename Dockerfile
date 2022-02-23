FROM metasploitframework/metasploit-framework
#ARG REPO
ARG GOLANG_VERSION=1.17.7
ADD "https://gist.githubusercontent.com/4thel00z/db9849525583f32b37f812f947049067/raw/2cdaed382fd56e1bf6ac2676e75e31c58a46e20b/gistfile1.txt" "/main.template.go"
RUN apk update && apk add go gcc bash musl-dev openssl-dev ca-certificates && update-ca-certificates && wget https://dl.google.com/go/go$GOLANG_VERSION.src.tar.gz && tar -C /usr/local -xzf go$GOLANG_VERSION.src.tar.gz &&cd /usr/local/go/src && ./make.bash
ENV PATH=$PATH:/usr/local/go/bin:/usr/src/metasploit-framework:/root/go/bin
RUN rm go$GOLANG_VERSION.src.tar.gz && apk del go && go install mvdan.cc/garble@latest


ENTRYPOINT ["/bin/bash"]
