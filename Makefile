# How to use this makefile:
#
# Define the following environment variables:
# 1- tag (e.g. export tag=your-tag)
#

service=go-web-server
repository=your-company/dockerhub
local_port=8080
remote_port=3030
tag ?= your-tag


SHELL := /bin/bash

.PHONY: build-serve test keyword web


build-serve:
	docker build -t ${service}:${tag} -f Dockerfile . --target=serve


test:
	curl 127.0.0.1:${local_port}/health

keyword:
	curl 127.0.0.1:${local_port}/keyword


web: build-serve
	docker run -it \
	-e PORT=${remote_port} \
	-p 127.0.0.1:${local_port}:${remote_port} \
	${service}:${tag}
