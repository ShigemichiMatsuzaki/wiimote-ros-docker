NAME=wiimote-ros
VERSION=dev

build:
	docker build -t $(NAME):$(VERSION) .
