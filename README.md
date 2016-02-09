# docker kongfig

## Run it

```bash
docker run --rm --link kong:kong \
	-v /path/to/kongfig.yml:/config.yml \
	mashupmill/kongfig \
	--host kong:8001 \
	--path /config.yml
```

## Environment Variables

| Name | Default Value | Description |
| ---- | ------------- | ----------- |
| `BETWEEN_START_DELAY` | 2 | Number of seconds between each check to see if kong is alive |
| `POST_START_DELAY` | 5 | Number of seconds to wait after we detect its started...seems like it takes a couple seconds after that |
| `CHECK_ATTEMPTS` | 20 | Number of attempts to check to see if kong is live |


## Example `docker-compose.yml`

```yml
cassandra:
  image: cassandra:2.2.4
  ports:
    - '9042:9042'

kong:
  # using un-official kong image which has a better startup script that waits
  # for cassandra to startup before trying to start kong
  image: articulate/kong-wait
  links:
    - 'cassandra:cassandra'
  ports:
    - '8000:8000' # http proxy port
    - '8443:8443' # https proxy port
    - '8001:8001' # http admin port
    - '7946:7946' # idk...their docs say to do it
    - '7946:7946/udp' # idk...their docs say to do it

kong-dashboard:
  image: pgbi/kong-dashboard
  ports:
    - '8002:8080'

kongfig:
  image: mashupmill/kongfig
  links:
    - 'kong:kong'
  volumes:
    - './config.yml:/config.yml'
  command: --path /config.yml --host kong:8001

```
