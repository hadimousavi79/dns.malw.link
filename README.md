# Запуск только DNS на сервере

1. Убедитесь, что у вас установлен Docker и Docker Compose.
2. Клонируйте нужную ветку:

   ```bash
   git clone --single-branch -b dns-server https://github.com/ImMALWARE/dns.malw.link
   cd dns.malw.link
   ```

## Если вам нужны DNS over HTTPS и DNS over TLS

1. Убедитесь, что домен привязан к IP.
2. Создайте папку `certs` и положите сертификаты `fullchain.cer` и `key.key`.

## Если вам не нужны DNS over HTTPS и DNS over TLS

1. В `docker-compose.yml` закомментируйте:

   ```yaml
   # - "853:853/tcp" # DNS over TLS
   # - "443:443/tcp" # DNS over HTTPS
   # - ./certs:/etc/dnsdist/certs:ro
   ```

2. В `dnsdist.conf` закомментируйте:

   ```dnsdist
   -- addTLSLocal("0.0.0.0:853", "/etc/dnsdist/certs/fullchain.cer", "/etc/dnsdist/certs/key.key")
   -- addDOHLocal("0.0.0.0:443", "/etc/dnsdist/certs/fullchain.cer", "/etc/dnsdist/certs/key.key", "/dns-query")
   ```

## Дальнейшие действия

В `dnsdist.conf` замените:

```dnsdist
addAction(QNameSuffixRule(proxy_with_subdomains), SpoofAction({"2a05:541:104:7f::1", "45.95.233.23", "185.246.223.127"}))
addAction(QNameSetRule(proxy), SpoofAction({"2a05:541:104:7f::1", "45.95.233.23", "185.246.223.127"}))
```

На IP-адреса вашего сервера SNI Proxy.

Узнать IP-адреса можно командами (выполните на сервере, где запущен SNI Proxy):

```bash
curl -4 ip.wtf  # IPv4
curl -6 ip.wtf  # IPv6
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