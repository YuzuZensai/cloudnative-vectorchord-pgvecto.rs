ARG CNPG_TAG

FROM ghcr.io/cloudnative-pg/postgresql:$CNPG_TAG

ARG CNPG_TAG
ARG VECTORCHORD_TAG
ARG PGVECTORS_TAG
ARG TARGETARCH

# drop to root to install packages
USER root
ADD https://github.com/tensorchord/pgvecto.rs/releases/download/$PGVECTORS_TAG/vectors-pg${CNPG_TAG%.*}_${PGVECTORS_TAG#"v"}_$TARGETARCH.deb ./pgvectors.deb
RUN apt install ./pgvectors.deb

ADD https://github.com/tensorchord/VectorChord/releases/download/$VECTORCHORD_TAG/postgresql-${CNPG_TAG%.*}-vchord_${VECTORCHORD_TAG#"v"}-1_$TARGETARCH.deb ./vchord.deb
RUN apt-get install -y ./vchord.deb && rm -f ./vchord.deb

USER postgres
