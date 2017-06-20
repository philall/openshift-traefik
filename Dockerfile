FROM scratch

COPY certs/ca-certificates.crt /etc/ssl/certs/
COPY traefik /

EXPOSE 8080 8443 8081

ENTRYPOINT ["/traefik"]
