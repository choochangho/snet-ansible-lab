# 환경 구성

## 작업 디렉토리 생성

```bash
$ mkdir snet-group-ansible
$ cd snet-group-ansible
$ mkdir mysqldata
$ mkdir semaphore
```

## 소스코드 clone

```bash
$ git clone https://github.com/choochangho/snet-ansible-lab.git .
```

# Dockerfile 수정

호스트의 CPU 아키텍쳐에 맞는 이미지 사용하도록 수정

```Docker

  db:   
    image: mysql
    command: --default-authentication-plugin=mysql_native_password
    restart: always
    volumes:
      - ./mysqldata:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=password
      - MYSQL_DATABASE=mydb
    ports:
      - "3306:3306"
```

image: mysql 을 다음과 같이 수정한다.

- Intel/AMD : image: mysql
- Apple 실리콘(m1/m2) : arm64v8/mysql

# 컨테이너 빌드 및 실행

```bash
$ docker-compose up
```

# 대시보드 확인

http://localhost:8000