NAME=wiimote-ros
VERSION=dev
CONTAINER_NAME=wiimote-ros

build:
	docker build -t $(NAME):$(VERSION) .
			
restart: stop start

start:
	docker start $(CONTAINER_NAME)
run:
	docker run -it \
    		--net host \
    		--runtime=nvidia \
    		-e DISPLAY=$$DISPLAY \
    		-v $$HOME/.Xauthority:/root/.Xauthority \
				-v $$PWD/catkin_ws:/root/catkin_ws/ \
				-v /media/aisl/E006B56406B53BFA1/Matsuzaki/dataset/label_traversed/:/root/label_traversed/ \
		--name $(CONTAINER_NAME) \
		$(NAME):$(VERSION)
					
contener=`docker ps -a -q`
image=`docker images | awk '/^<none>/ { print $$3 }'`
	
clean:
	@if [ "$(image)" != "" ] ; then \
		docker rmi $(image); \
	fi
	@if [ "$(contener)" != "" ] ; then \
		docker rm $(contener); \
	fi
	
stop:
	docker rm -f $(CONTAINER_NAME)
	
attach:
	docker start $(CONTAINER_NAME) && docker exec -it $(CONTAINER_NAME) /bin/bash
	
logs:
	docker logs $(CONTAINER_NAME)

rm:
	docker rm $(CONTAINER_NAME)
