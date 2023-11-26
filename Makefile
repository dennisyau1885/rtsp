SHELL         = bash
RTSP          = rtsp://localhost:554
API           = http://localhost:9997/v3
CURL          = curl 2>&1 -v -s
CONTENT_TYPE  = -H "Content-Type: application/json"
HTTP_200      = grep "HTTP/.* 200 OK"
RTSP_200      = grep "RTSP/.* 200 OK"

default: restart

up:
	docker compose up -d

down:
	docker compose down

restart: down up sleep test

sleep:
	sleep 1

test: rtsp post list count_timer count_restream delete

rtsp:
	$(CURL) -X DESCRIBE $(RTSP) | $(RTSP_200)

list:
	curl -s $(API)/paths/list | jq '.items[] | { name, readers }'

count_timer count_restream:
	@curl -s $(API)/paths/list \
	| jq --arg PATHNAME "$$(echo $@ | cut -d"_" -f2)" \
	  '.items[] | select(.name == $$PATHNAME) | .readers | length'

post:
	$(CURL) $(CONTENT_TYPE) -X POST -d @path.json $(API)/config/paths/add/restream | $(HTTP_200)

delete:
	$(CURL) -X DELETE $(API)/config/paths/delete/restream | $(HTTP_200)
