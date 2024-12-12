# envoy-jwt-auth

## Setup

```sh
mise install
luarocks make
```

## Testing

### Unit tests

```sh
lua envoy/jwt_authorization_filter_spec.lua -c -v --shuffle
```

### Integration tests

```sh
docker compose up
```

```sh
$ curl --location 'localhost:8000' --header 'Authorization: Bearer ey...'
{"host":{"hostname":"localhost","ip":"::ffff:192.168.107.2","ips":[]},"http":{"method":"GET","baseUrl":"","originalUrl":"/","protocol":"http"},"request":{"params":{"0":"/"},"query":{},"cookies":{},"body":{},"headers":{"host":"localhost:8000","user-agent":"curl/8.7.1","accept":"*/*","x-forwarded-proto":"http","x-request-id":"1d6a0e97-fcdb-4df4-bc3a-83a0bf0ec3d9","x-envoy-expected-rq-timeout-ms":"15000","authorization":"Basic base64EncodedCredentials"}},"environment":{ ... }}% 
```
