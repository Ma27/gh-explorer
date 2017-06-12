FROM haskell:8.0

WORKDIR /opt/server
RUN cabal update

COPY . /opt/server
RUN cabal install

ENV PATH /root/.cabal/bin:$PATH

ENTRYPOINT ["gh-explorer"]
