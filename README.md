# Запуск только SNI Proxy на сервере

1. Убедитесь, что у вас установлен Docker и Docker Compose.

2. Клонируйте ветку:

   ```bash
   git clone --single-branch -b sni-proxy https://github.com/ImMALWARE/dns.malw.link
   cd dns.malw.link
   ```

3. Для запуска/обновления списка доменов используйте:

   ```bash
   ./update_domains.sh
   ```