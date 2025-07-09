# cnpgvecto.rs
Container images for [cloudnative-pg](https://cloudnative-pg.io/) with [VectorChord](https://github.com/tensorchord/VectorChord) and [pgvecto.rs](https://github.com/tensorchord/pgvecto.rs) extension installed.


> [!IMPORTANT]
> If you are using this image on an existing database, the postgres configuration needs to be 
> altered to enable the extension. You can do this by setting shared_preload_libraries in your Cluster spec:
> ```yaml
> apiVersion: postgresql.cnpg.io/v1
> kind: Cluster
> spec:
>   (...)
>   postgresql:
>     shared_preload_libraries:
>       - "vectors.so"
>       - "vchord.so"
>   ```

> [!IMPORTANT]
> The `pgvecto.rs` and `VectorChord` extension is not enabled by default. You need to enable it and set the search path when initializing the database. You can configure it in your Cluster spec:
> ```yaml
> apiVersion: postgresql.cnpg.io/v1
> kind: Cluster
> spec:
>   (...)
>   bootstrap:
>     initdb:
>       postInitSQL:
>         - ALTER SYSTEM SET search_path TO "$user", public, vectors;
>         - CREATE EXTENSION IF NOT EXISTS "vectors";
>         - CREATE EXTENSION IF NOT EXISTS vchord CASCADE;

## Building

To build the Dockerfile locally, you need to pass the `CNPG_TAG`, `PGVECTORS_TAG` and `VECTORCHORD_TAG` args. For example:  
`docker build . --build-arg="CNPG_TAG=17.5-bookworm" --build-arg="PGVECTORS_TAG=v0.4.0" --build-arg="VECTORCHORD_TAG=0.4.3"`