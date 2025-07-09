ARG CNPG_TAG

FROM ghcr.io/cloudnative-pg/postgresql:$CNPG_TAG

ARG CNPG_TAG
ARG VECTORCHORD_TAG
ARG PGVECTORS_TAG
ARG TARGETARCH

# drop to root to install packages
USER root

RUN apt update && apt install -y curl wget

# Extract PostgreSQL major version from CNPG_TAG (handles formats like "17.5-bookworm" -> "17")
RUN PG_MAJOR=$(echo $CNPG_TAG | cut -d'-' -f1 | cut -d'.' -f1) && \
    curl -L -o ./pgvectors.deb "https://github.com/tensorchord/pgvecto.rs/releases/download/$PGVECTORS_TAG/vectors-pg${PG_MAJOR}_${PGVECTORS_TAG#"v"}_$TARGETARCH.deb" && \
    apt install -y ./pgvectors.deb && \
    rm -f ./pgvectors.deb

RUN PG_MAJOR=$(echo $CNPG_TAG | cut -d'-' -f1 | cut -d'.' -f1) && \
    curl -L -o ./vchord.deb "https://github.com/tensorchord/VectorChord/releases/download/$VECTORCHORD_TAG/postgresql-${PG_MAJOR}-vchord_${VECTORCHORD_TAG}-1_$TARGETARCH.deb" && \
    apt install -y ./vchord.deb && \
    rm -f ./vchord.deb

# go back to postgres user  
USER postgres
