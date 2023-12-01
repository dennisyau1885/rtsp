# MediaMTX - Video Restreamer

## Minimal docker compose file to;
- loop an mp4 as rtsp
- restream rtsp
- use API to create and delete a rtsp restream (see Makefile)


## Notes
On WSL you might need to comment out `network_mode: host`
can add restreams into `path:` in mediamtx.yml file if you don't want to use ENVs
TODO: example of `record` stream to disk

## References
- README https://github.com/bluenviron/mediamtx#on-demand-publishing
- API https://bluenviron.github.io/mediamtx/#operation/configPathsList
- CONFIG https://github.com/bluenviron/mediamtx/blob/main/mediamtx.yml

