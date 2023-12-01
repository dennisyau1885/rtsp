SHELL         = bash
RTSP          = rtsp://localhost:554
API           = http://localhost:9997/v3
CURL          = curl 2>&1 -v -s
CONTENT_TYPE  = -H "Content-Type: application/json"
HTTP_200      = grep "HTTP/.* 200 OK"
RTSP_200      = grep "RTSP/.* 200 OK"

default: restart sleep test

up:
	docker compose up -d

down:
	docker compose down

restart: down up

sleep:
	sleep 1

test: rtsp count_timer count_restream delete list post get

rtsp:
	# Is the MediaMTX up?!
	$(CURL) -X DESCRIBE $(RTSP) | $(RTSP_200)

list:
	# List paths and readers (if any)
	curl -s $(API)/paths/list | jq '.items[] | { name, readers }'

count_timer count_restream:
	# Count readers per stream
	@echo $@ | cut -d_ -f2
	@curl -s $(API)/paths/list \
	| jq --arg PATHNAME "$$(echo $@ | cut -d_ -f2)" \
	  '.items[] | select(.name == $$PATHNAME) | .readers | length'

post:
	# Add 'restream'
	$(CURL) $(CONTENT_TYPE) -X POST -d @restream.json $(API)/config/paths/add/restream | $(HTTP_200)

get:
	# Get 'restream' info
	$(CURL) 2>/dev/null $(CONTENT_TYPE) $(API)/config/paths/get/restream | jq .

delete:
	# Delete 'restream'
	$(CURL) -X DELETE $(API)/config/paths/delete/restream | $(HTTP_200)

mediamtx.yml:
	curl https://raw.githubusercontent.com/bluenviron/mediamtx/main/mediamtx.yml -o mediamtx.yml	
