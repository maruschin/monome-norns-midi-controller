ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

run:
	docker run --rm -it \
		--name=norns \
		--ulimit rtprio=95 \
		--ulimit memlock=-1 \
		--shm-size=256m \
		-v $(ROOT_DIR)/src/:/home/we/dust/code/control \
		-p 5000:5000 \
		-p 5555:5555 \
		-p 5556:5556 \
		-p 5900:5900 \
		-p 8889:8889 \
		-p 10111:10111 \
		wwinder/norns-test-dummy

test:
	cd src && ./tests/run.lua -v
