SHELL = bash
HTTP_200 = grep "HTTP/.* 200 OK"
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
	curl -v -X DESCRIBE rtsp://localhost:554 2>&1 \
	| grep "RTSP.* 200 OK"

list:
	curl -s http://localhost:9997/v3/paths/list | jq '.items[] | { name, readers }'

count_timer count_restream:
	@curl -s localhost:9997/v3/paths/list \
	| jq --arg PATHNAME "$$(echo $@ | cut -d"_" -f2)" \
	  '.items[] | select(.name == $$PATHNAME) | .readers | length'

post:
	curl -s -v -X POST -H "Content-Type: application/json" -d @post_path.json http://localhost:9997/v3/config/paths/add/restream 2>&1 \
	| $(HTTP_200)

delete:
	curl -s -v -X DELETE http://localhost:9997/v3/config/paths/delete/restream 2>&1 \
	| $(HTTP_200)
