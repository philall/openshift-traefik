FROM scratch

COPY traefik /

EXPOSE 8080 8443 8081

ENTRYPOINT ["/traefik"]
