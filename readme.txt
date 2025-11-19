🚀 Yeni Kullanım Talimatı
Yeni projenizin klasöründe, yukarıdaki Dockerfile içeriğini güncelleyin. Diğer üç dosyanın ( docker-compose.yml, custom.ini, supervisord.conf) doğru olduğundan emin olun.

Konteyneri yeniden oluşturmak ve başlatmak için terminalde aşağıdaki komutu çalıştırın:

Bash

docker-compose up --build -d
Konteynerin içine girdikten sonra (ssh mahmut@localhost -p 2222 ile veya docker exec ile) artık hem nano editörünü kullanabilir hem de Node.js komutlarını (node -v, npm install, Next.js build komutları) çalıştırabilirsiniz.

Not: Next.js bir Node.js uygulaması olduğu için, projeyi çalıştırmak için ayrıca npm run dev veya npm run start gibi komutları SSH üzerinden veya docker exec ile manuel olarak çalıştırmanız gerekecektir. Apache sadece PHP dosyalarınızı sunacaktır.