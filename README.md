# ubudev
Ubuntu for development

## 利用手順

### 1. `authorized_keys` を修正する

```
$ cat docker/ssh/authorized_keys
ssh-rsa xxxxxx== xxxx
```

上記ファイルを自分の信頼するキーに修正する

### 2. ユーザ名の変更

ユーザ名を変更したい場合は `docker/Dockerfile` の `USER` と `docker-compose.yml` を修正する

### 3. docker image 作成 & 起動

```
$ docker-compose build
$ docker-compose up -d
```

### 4. ブラウザから `code-server` に接続する

```
https://localhost:18443/
```

### 5. その他

* code-server 接続時のパスワードは `server.env` の `PASSWORD` に設定する
* 接続ポートを変更したい場合は `docker-compose.yml` の `ports` を修正する
* SSL の証明書は [mkcert][1] を導入するなどして、`etc` 配下に同名のファイルを作成する

[1]: https://github.com/FiloSottile/mkcert
