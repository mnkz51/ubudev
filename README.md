# ubudev
Ubuntu for development

## 利用手順

### 1. `authorized_keys` を修正する

```
$ cat docker/ssh/authorized_keys
ssh-rsa xxxxxx== xxxx
```

上記ファイルを自分の信頼するキーに修正する

### 2. docker image 作成 & 起動

```
$ docker-compose build
$ docker-compose up -d
```

### 3. ssh して接続する

```
$ ssh -p 14022 mine@localhost
```

* ユーザ名を変更したい場合は `docker/Dockerfile` の `USER` を修正する
* 接続ポートを変更したい場合は `docker-compose.yml` の `ports` を修正する
