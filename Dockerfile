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
    VERSION_NUM=${PGVECTORS_TAG#"v"} && \
    if [ "$PG_MAJOR" = "17" ] && [ "$VERSION_NUM" = "0.3.0" ]; then \
        # Special case for PG17 with v0.3.0 - use vectors variant
        curl -L -o ./pgvectors.deb "https://github.com/tensorchord/pgvecto.rs/releases/download/v$PGVECTORS_TAG/vectors-pg${PG_MAJOR}_${VERSION_NUM}_${TARGETARCH}_vectors.deb"; \
    else \
        # Standard naming for other versions
        curl -L -o ./pgvectors.deb "https://github.com/tensorchord/pgvecto.rs/releases/download/v$PGVECTORS_TAG/vectors-pg${PG_MAJOR}_${VERSION_NUM}_$TARGETARCH.deb"; \
    fi && \
    apt install -y ./pgvectors.deb && \
    rm -f ./pgvectors.deb

RUN PG_MAJOR=$(echo $CNPG_TAG | cut -d'-' -f1 | cut -d'.' -f1) && \
    curl -L -o ./vchord.deb "https://github.com/tensorchord/VectorChord/releases/download/$VECTORCHORD_TAG/postgresql-${PG_MAJOR}-vchord_${VECTORCHORD_TAG}-1_$TARGETARCH.deb" && \
    apt install -y ./vchord.deb && \
    rm -f ./vchord.deb

# go back to postgres user  
USER postgres
