#!/bin/bash

docker rm -f couch1 couch2 couch3

docker run -d \
	-p 15984:5984 \
	-p 15986:5986 \
	-e NODENAME=node1.couch.local \
	-e COUCHDB_USER=admin \
	-e COUCHDB_PASSWORD=admin \
	-e ERLANG_COOKIE=monster \
	--network=couchdb_net \
	--network-alias=node1.couch.local \
	--name=couch1 \
	couchdb:2.0-alz

docker run -d \
	-p 25984:5984 \
	-p 25986:5986 \
	-e NODENAME=node2.couch.local \
	-e COUCHDB_USER=admin \
	-e COUCHDB_PASSWORD=admin \
	-e ERLANG_COOKIE=monster \
	--network=couchdb_net \
	--network-alias=node2.couch.local \
	--name=couch2 \
	couchdb:2.0-alz

docker run -d \
	-p 35984:5984 \
	-p 35986:5986 \
	-e NODENAME=node3.couch.local \
	-e COUCHDB_USER=admin \
	-e COUCHDB_PASSWORD=admin \
	-e ERLANG_COOKIE=monster \
	--network=couchdb_net \
	--network-alias=node3.couch.local \
	--name=couch3 \
	couchdb:2.0-alz


curl -X PUT http://localhost:15986/_nodes/couchdb@node2.couch.local -d {} -u admin
curl -X PUT http://localhost:15986/_nodes/couchdb@node3.couch.local -d {} -u admin

curl -X PUT http://localhost:15984/_global_changes -d {} -u admin
curl -X PUT http://localhost:15984/_metadata -d {} -u admin
curl -X PUT http://localhost:15984/_replicator -d {} -u admin
curl -X PUT http://localhost:15984/_users -d {} -u admin

