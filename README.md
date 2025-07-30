# Запуск DNS и SNI Proxy на одном сервере

1. Убедитесь, что у вас установлен Docker и Docker Compose. Если не знаете как — спросите у ChatGPT.
2. Клонируйте репозиторий:

   ```bash
   git clone --single-branch -b dns-and-sni-proxy https://github.com/ImMALWARE/dns.malw.link
   cd dns.malw.link
   ```

## Если вам нужны DNS over HTTPS и DNS over TLS

1. Убедитесь, что ваш домен привязан к IP сервера.
2. Создайте папку `certs` в корне проекта.
3. Поместите в неё SSL-сертификаты с именами `fullchain.cer` и `key.key`.

   > Можете использовать, например, [acme.sh](https://github.com/acmesh-official/acme.sh) для получения сертификатов.

## Если вам не нужны DNS over HTTPS и DNS over TLS

1. В `docker-compose.yml` закомментируйте строки:

   ```yaml
   # - "853:853/tcp"
   # - ./certs:/etc/dnsdist/certs:ro
   ```

2. В `dnsdist.conf` закомментируйте строки:

   ```dnsdist
   -- addTLSLocal("0.0.0.0:853", "/etc/dnsdist/certs/fullchain.cer", "/etc/dnsdist/certs/key.key")
   -- addDOHLocal("0.0.0.0:8053", "/etc/dnsdist/certs/fullchain.cer", "/etc/dnsdist/certs/key.key", "/dns-query")
   ```

## Дальнейшие действия

В файле `dnsdist.conf` замените IP-адреса:

```dnsdist
addAction(QNameSuffixRule(proxy_with_subdomains), SpoofAction({"2a05:541:104:7f::1", "45.95.233.23", "185.246.223.127"}))
addAction(QNameSetRule(proxy), SpoofAction({"2a05:541:104:7f::1", "45.95.233.23", "185.246.223.127"}))
```

Замените на IP-адреса текущего сервера. Чтобы его узнать, выполните эти команды:

```bash
curl -4 ip.wtf  # IPv4 адрес
curl -6 ip.wtf  # IPv6 адрес
```

Формат:

```json
{"тут ipv6", "тут ipv4"}
```

Если IPv6 нет:

```json
{"тут ipv4"}
```

Для запуска/обновления списка доменов используйте:

```bash
./update_domains.sh
```