DB_CONTAINER_NAME = ih13_db_1
DB_NAME = system_sample

depinstall: 
	go get -u github.com/golang/dep/...

dep:
	cd server/ && \
	dep init

build:
	sudo docker-compose up -d --build

init: dep build initdb
reset:
	cd server && \
	rm Gopkg.toml && \
	rm Gopkg.lock && \
	rm -rf vendor

ps:
	sudo docker-compose ps

up:
	sudo docker-compose up -d

stop:
	sudo docker-compose stop

rm:
	sudo docker-compose rm

restart:
	sudo docker-compose restart

logs:
	sudo docker-compose logs

stopup: stop up ps

initdb:
	cat db/create_db.sql | sudo docker exec -i $(DB_CONTAINER_NAME) mysql -h 127.0.0.1 -uroot -proot
	cat db/create_table.sql | sudo docker exec -i $(DB_CONTAINER_NAME) mysql -h 127.0.0.1 -uroot -proot $(DB_NAME)

macinit: dep macbuild macinitdb
macbuild:
	docker-compose up -d --build
macrestart:
	docker-compose restart
macinitdb:
	cat db/create_db.sql | docker exec -i $(DB_CONTAINER_NAME) mysql -h 127.0.0.1 -uroot -proot
	cat db/create_table.sql | docker exec -i $(DB_CONTAINER_NAME) mysql -h 127.0.0.1 -uroot -proot $(DB_NAME)

