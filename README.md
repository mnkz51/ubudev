# ubudev
Ubuntu for development

## 利用手順

### 1. `authorized_keys` を修正する

```
$ cat docker/code-server/ssh/authorized_keys
ssh-rsa xxxxxx== xxxx
```

上記ファイルを自分の信頼するキーに修正する

### 2. ユーザ名の変更

ユーザ名を変更したい場合は `docker/code-server/Dockerfile` の `USER` と `docker-compose.yml` を修正する

### 3. docker image 作成 & 起動

```
$ docker-compose build
$ docker-compose up -d
```

### 4. ブラウザから [code-server][1] に接続する

```
https://localhost/
```

### 5. その他の設定

* code-server 接続時のパスワードは `server.env` の `PASSWORD` に設定する
* 接続ポートを変更したい場合は `docker-compose.yml` の `ports` を修正する
* SSL の証明書は [mkcert][2] を導入するなどして、`etc` 配下に同名のファイルを作成する

## バックアップとリストア

### 1. バックアップ用 docker image 作成

```
$ cd volume-backup
volume-backup$ docker-compose build
```

### 2. バックアップ

```
volume-backup$ docker-compose run --rm app ./backup.sh backup
```

`backup` ディレクトリ内の日時フォルダ内に volume 配下のディレクトリごとの圧縮ファイルが作成される

### 3. リストア

```
volume-backup$ docker-compose run --rm app ./backup.sh restore [archive_file]
```

`archive_file` には `backup` ディレクトリからの相対指定 (ex. `20190102-150405/works.tar.bz2` )

[1]: https://github.com/cdr/code-server
[2]: https://github.com/FiloSottile/mkcert
