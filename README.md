## ZUP Web

    ZUP Web
    Copyright (C) <2014> <Instituto TIM>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as
    published by the Free Software Foundation, either version 3 of the
    License, or (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
--- 

Este repositório contém os arquivos necessários para construir uma imagem Docker contendo o Painel, Aplicativo Web 
Cidadão e Landing Page do projeto ZUP. Para projetos que utilizem dois ou mais desses componentes, esse repositório pode
ser utilizado para facilitar o processo de deploy.

## Build da imagem

Primeiramente, atualize as pastas `zup-landingpage`, `zup-painel` e `zup-web-angular` com a build de produção (pasta `dist`)
dos respectivos componentes. Após isso basta executar o seguinte comando:

```
docker build -t zup-web:latest .
```

Isso fará com que uma imagem `zup-web` com a tag `latest` seja gerada.


## Configuração e execução

Crie um arquivo `web.env` em uma localização de sua preferência. Dentro desse arquivo, coloque em cada linha qualquer uma das
variáveis oferecidas pelo Painel, Cidadão Web e Landing Page. Após isso, basta rodar a imagem com o seguinte comando:

```
docker run -d --name zup-web --env-file /algum/caminho/web.env -p 80:80 zup-web:latest
```

O servidor irá servir os arquivos na porta 80 do host do Docker.
