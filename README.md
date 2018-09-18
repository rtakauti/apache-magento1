<p align="center"><img src ="https://vindi-blog.s3.amazonaws.com/wp-content/uploads/2017/10/logo-vindi-1.png" /></p>

##
# Vindi - Magento Recorrente

[![Licença do Software][badge-license]](LICENSE)
[![Última Versão no GitHub][badge-versionGitHub]][link-GitHub-release]
[![GitHub commits desde a última Versão][badge-versionGitHub-commits]][link-GitHub-release]

# Descrição
A integração do módulo da Vindi permite criação e gestão de planos e assinaturas através do Magento de forma transparente.

# Iniciar uma instância do Vindi - Magento Recorrente

### Iniciar uma instância do Vindi - Magento Recorrente é bem simples:

É necessário criar uma rede com o nome webproxy

```
docker network create webproxy
```

docker-compose.yml:

```
version: '3.3'
services:
    selenium:
        image: selenium/hub
        container_name: selenium
        ports:
         - "4444"
    chrome:
        image: selenium/node-chrome
        container_name: chrome
        depends_on:
         - selenium
        links:
         - selenium:hub
        environment:
         - HUB_HOST=selenium
         - HUB_PORT=4444
    magento1db:
        image: vindi/mysql-magento1
        container_name: magento1_db
        ports:
         - "3306"
    magento1web:
        image: vindi/apache-magento1
        container_name: magento1_web
        depends_on:
         - magento1db
         - chrome
        ports:
        - "443:443"
        links:
         - magento1db:mysql
         - chrome
networks:
  default:
    external:
      name: webproxy

```

## Rodar os testes

```
composer test
```

## Dúvidas
Caso necessite de informações sobre a plataforma ou API por favor siga através do canal [Atendimento Vindi](http://atendimento.vindi.com.br/hc/pt-br)

## Créditos
- [Vindi](https://github.com/vindi)
- [Todos os Contribuidores](https://github.com/vindi/vindi-magento/contributors)

## Licença
GNU GPLv3. Por favor, veja o [Arquivo de Licença](LICENSE) para mais informações.

[badge-license]: https://img.shields.io/badge/license-GPLv3-blue.svg
[badge-versionGitHub]: https://img.shields.io/github/release/vindi/vindi-magento.svg
[badge-versionGitHub-commits]:  https://img.shields.io/github/commits-since/vindi/vindi-magento/latest.svg


[link-GitHub-release]: https://github.com/vindi/vindi-magento/releases