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

ユーザ名を変更したい場合は `docker/code-server/Dockerfile` の `USER` と `compose.yml` を修正する

### 3. docker image 作成 & 起動

```
$ docker compose build
$ docekr compose up -d
```

### 4. 接続する

```
$ docker compose exec app bash -l
```

### 5. その他の設定

* 接続ポートを変更したい場合は `compose.yml` の `ports` を修正する

## バックアップとリストア

### 1. バックアップ用 docker image 作成

```
$ cd volume-backup
volume-backup$ docker compose build
```

### 2. バックアップ

```
volume-backup$ docker compose run --rm save ./backup.sh backup
```

`backup` ディレクトリ内の日時フォルダ内に volume 配下のディレクトリごとの圧縮ファイルが作成される

### 3. リストア

```
volume-backup$ docker compose run --rm save ./backup.sh restore [archive_file]
```

`archive_file` には `backup` ディレクトリからの相対指定 (ex. `20190102-150405/works.tar.bz2` )
