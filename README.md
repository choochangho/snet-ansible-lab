# 환경 구성

## WSL 

설치방법 참고 [윈도우 10, WSL, Docker](https://velog.io/@hanjuli94/%EC%9C%88%EB%8F%84%EC%9A%B0%EC%97%90%EC%84%9C-%EB%8F%84%EC%BB%A4-%EC%8B%A4%EC%8A%B5%ED%95%98%EA%B8%B0)

## 작업 디렉토리 생성

```bash
mkdir snet-group-ansible
cd snet-group-ansible
mkdir mysqldata
mkdir semaphore
```

## 소스코드 clone

```bash
git clone https://github.com/choochangho/snet-ansible-lab.git .
```

## (Option)Dockerfile 수정

docker-compose.yaml에서 호스트의 CPU 아키텍쳐에 맞는 이미지 사용하도록 수정

<pre>
  db:   
    <b>image: mysql</b>
    command: --default-authentication-plugin=mysql_native_password
    restart: always
    volumes:
      - ./mysqldata:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=password
      - MYSQL_DATABASE=mydb
    ports:
      - "3306:3306"
</pre>

`image: mysql` 을 다음과 같이 수정한다.

- Intel/AMD : `image: mysql`
- Apple 실리콘(m1/m2) : `image: arm64v8/mysql`

## 컨테이너 빌드 및 실행

```bash
docker-compose up [-d]
```

## 대시보드 확인

http://localhost:8000

## Mac M1/M2 사용자를 위한 Tip

:fire: Dockerfile 과 Dockerfile-ansible의 base image를 다음과 같이 변경하면 호스트 CPU와 동일한 아키텍쳐를 사용하므로써 성능향상에 도움이 된다.

```
FROM arm64v8/ubuntu:20.04
```