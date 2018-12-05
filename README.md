# TRABALHO 01 : ÓTICA

Trabalho desenvolvido durante a disciplina de Banco de Dados II.

## SUMÁRIO

- [TRABALHO 01 : ÓTICA](#trabalho-01--%C3%B3tica)
    - [SUMÁRIO](#sum%C3%A1rio)
    - [1 COMPONENTES](#1-componentes)
        - [1.1 Integrantes do grupo](#11-integrantes-do-grupo)
    - [2 INTRODUÇÃO E MOTIVAÇÃO](#2-introdu%C3%A7%C3%A3o-e-motiva%C3%A7%C3%A3o)
    - [3 MINI-MUNDO](#3-mini-mundo)
    - [4 RASCUNHOS BÁSICOS DA INTERFACE](#4-rascunhos-b%C3%A1sicos-da-interface)
    - [5 MODELO CONCEITUAL](#5-modelo-conceitual)
        - [5.1 NOTACAO ENTIDADE RELACIONAMENTO](#51-notacao-entidade-relacionamento)
        - [5.2 DECISÕES DE PROJETO](#52-decis%C3%B5es-de-projeto)
        - [5.3 DESCRIÇÃO DOS DADOS](#53-descri%C3%A7%C3%A3o-dos-dados)
            - [5.3.1 DOMÍNIO IDENTIDADE](#531-dom%C3%ADnio-identidade)
            - [5.3.2 DOMÍNIO PAGAMENTO](#532-dom%C3%ADnio-pagamento)
            - [5.3.3 DOMÍNIO FISCAL](#533-dom%C3%ADnio-fiscal)
            - [5.3.4 DOMÍNIO SERVIÇO](#534-dom%C3%ADnio-servi%C3%A7o)
            - [5.3.5 DOMÍNIO ESTOQUE](#535-dom%C3%ADnio-estoque)
    - [6 MODELO LÓGICO](#6-modelo-l%C3%B3gico)
    - [7 MODELO FÍSICO](#7-modelo-f%C3%ADsico)
    - [8 INSERT APLICADO NAS TABELAS DO BANCO DE DADOS](#8-insert-aplicado-nas-tabelas-do-banco-de-dados)
        - [8.1 SCRIPT PARA CRIAÇÃO DE TABELAS E INSERÇÃO DOS DADOS](#81-script-para-cria%C3%A7%C3%A3o-de-tabelas-e-inser%C3%A7%C3%A3o-dos-dados)
    - [9 TABELAS E PRINCIPAIS CONSULTAS](#9-tabelas-e-principais-consultas)
        - [9.1 LISTA DE CODIGOS DAS FUNÇÕES, ASSERÇOES E TRIGGERS](#91-lista-de-codigos-das-fun%C3%A7%C3%B5es-asser%C3%A7oes-e-triggers)
            - [9.1.1 `AUTH`](#911-auth)
        - [9.2 GERACAO DE DADOS (MÍNIMO DE 1,5 MILHÃO DE REGISTROS PARA PRINCIPAL RELAÇAO)](#92-geracao-de-dados-m%C3%ADnimo-de-15-milh%C3%A3o-de-registros-para-principal-rela%C3%A7ao)
        - [9.3 BACKUP](#93-backup)
        - [9.4 APLICAÇAO DE ÍNDICES E TESTES DE PERFORMANCE](#94-aplica%C3%A7ao-de-%C3%ADndices-e-testes-de-performance)

## 1 COMPONENTES

### 1.1 Integrantes do grupo

- Sávio Santos Serra

## 2 INTRODUÇÃO E MOTIVAÇÃO

Através da observação da dificuldade em gerir dados de clientes, pagamentos e vendas em uma ótica, pensou-se em um sistema que facilitasse essa gestão.

## 3 MINI-MUNDO

> A ótica X atualmente realiza o controle de ordens de serviço e pagamentos de clientes manualmente, aspectos esses que mais impactam em sua receita. Contudo, existe uma grande dificuldade para verificar quando uma ordem de serviço foi solicitada, ou quando um pagamento deve ser realizado. Assim, a ótica tem interesse em um sistema que possa automatizar tais interações e extrair relatórios do sistema, como pagamentos a serem recebidos em certo mês, ordens de serviço solicitadas, funcionários mais ativos, receita bruta, entre outros.

> O processo atualmente ocorre da seguinte forma:
>- Um cliente solicita uma venda. Caso ele já possua ficha no estabelecimento, sua ficha é resgatada; caso contrário, é criada. A venda pode ser sobre vários items, como armações e lentes.
>- Caso um item seja uma lente, será necessário o envio de uma ordem de serviço para um laboratório para produzir a lente (e montar caso acompanhe a armação). A lente é feita com base em uma receita prescrita por um profissinal oftalmologista.
>- Uma vez que o laboratório entrega a ordem de serviço, o cliente é notificado e pode buscar o item na loja.

## 4 RASCUNHOS BÁSICOS DA INTERFACE

<Inserir aqui>

## 5 MODELO CONCEITUAL

### 5.1 NOTACAO ENTIDADE RELACIONAMENTO

![Otica](https://i.imgur.com/RYtWGyO.png)

### 5.2 DECISÕES DE PROJETO

> **Campos Id**: Todos os campos que se referem à `id`s foram implementados utilizando o tipo [`uuid`](https://www.postgresql.org/docs/9.1/datatype-uuid.html). Essa decisão foi tomada para evitar problemas futuros ao realizar merge com réplicas do banco de dados, onde chaves poderiam colidir. Outro motivo por trás dessa decisão é obscurecer a chave primária, uma vez que essa pode ser exposta em um web-service.

> **Perfis**: Ao invés de herança, foi adotada uma estratégia focada em perfis: uma entidade do sistema possui vários perfis. Perfis possuem tipos (definidos na tabela `profile_schemas`), e seus atributos são representados na tabela `profile_characteristics`. Isso permite que novos atributos possam ser adicionados ou desabilitados sem que a estrutura do banco de dados mude, abrindo mão de performance.
 
> **Itens**: No mini-mundo, uma venda é constituida por itens e ordens de serviço. Porém, ordens de serviços também podem conter itens. Optou-se para que a tabela `items_stock` possua ambas as chaves estrangeiras, existindo a possibilidade que o campo `service_id` seja nulo.

### 5.3 DESCRIÇÃO DOS DADOS

#### 5.3.1 DOMÍNIO IDENTIDADE

| Tabela                         | Descrição                                                                                                                                            |
| :----------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| `states`                       | Relação de estados (localização).                                                                                                                    |
| `cities`                       | Relação de cidades (localização).                                                                                                                    |
| `clients`                      | Relação de entidades do sistema. Cada entidade possui vários perfis.                                                                                 |
| `addresses`                    | Relação de endereços. Cada perfil possui no máximo um endereço.                                                                                      |
| `contact_types`                | Relação dos tipos de dados de contatos, como telefone.                                                                                               |
| `user_characteristics`         | Relação de todas as características que um perfil pode ter.                                                                                          |
| `profile_schemas`              | Relação dos esquemas de perfis. Exemplo: Cliente, Funcionário, Médico.                                                                               |
| `schema_characteristics`       | Junto com a tabela `profile_schemas`, define o conjunto de características que um determinado perfil pode ter. Exemplo: Funcionário: Senha, Login... |
| `profiles`                     | Relação dos perfis existentes. Um perfil possui um esquema a qual pertence.                                                                          |
| `contacts`                     | Relação das informações de contato dos perfis.                                                                                                       |
| `profile_characteristics`      | Relação das informações dos perfis.                                                                                                                  |
| `tokens`                       | Relação dos tokens de sessão de usuários logados.                                                                                                    |
| `prescriptions`                | Relação das receitas médicas.                                                                                                                        |
| `prescription_characteristics` | Relação dos tipos de dados das receitas.                                                                                                             |
| `prescription_infos`           | Relação das informações das receitas.                                                                                                                |

#### 5.3.2 DOMÍNIO PAGAMENTO

| Tabela            | Descrição                                         |
| :---------------- | ------------------------------------------------- |
| `payment_methods` | Relação dos métodos de pagamento disponíveis.     |
| `payments`        | Relação dos pagamentos (executados ou previstos). |
| `sales`           | Relação das vendas.                               |



#### 5.3.3 DOMÍNIO FISCAL

| Tabela     | Descrição                  |
| :--------- | -------------------------- |
| `invoices` | Relação das notas fiscais. |

#### 5.3.4 DOMÍNIO SERVIÇO

| Tabela             | Descrição                                        |
| :----------------- | ------------------------------------------------ |
| `statuses`         | Relação dos estados que um serviço pode assumir. |
| `services`         | Relação dos serviços.                            |
| `service_statuses` | Relação do histórico de estados dos serviços.    |

#### 5.3.5 DOMÍNIO ESTOQUE

| Tabela            | Descrição                                                 |
| :---------------- | --------------------------------------------------------- |
| `items_stock`     | Relação de todos os itens.                                |
| `item_categories` | Relação das categorias de itens. Exemplo: Armação, Lente. |

## 6 MODELO LÓGICO

## 7 MODELO FÍSICO

![ModeloFisico](https://i.imgur.com/fHz0c1G.png)

## 8 INSERT APLICADO NAS TABELAS DO BANCO DE DADOS

![Seed](https://i.imgur.com/ydPTiL1.gif)

### 8.1 SCRIPT PARA CRIAÇÃO DE TABELAS E INSERÇÃO DOS DADOS

> Verificar `create.sql` na pasta artifacts/sql.

## 9 TABELAS E PRINCIPAIS CONSULTAS

```sql
SELECT * FROM CONTACTS LIMIT 100
```
![](https://i.imgur.com/KpgpBTm.png)


```sql
SELECT * FROM INVOICES LIMIT 100
```
![](https://i.imgur.com/jYvd5vh.png)

```sql
SELECT * FROM ITEMS_STOCK LIMIT 100
```
![](https://i.imgur.com/DW8qnYy.png)

```sql
SELECT * FROM SALES LIMIT 100
```
![](https://i.imgur.com/IUONLzc.png)

```sql
SELECT PROFILE_CHARACTERISTICS.CHARACTERISTIC_INFO, COUNT(*) AS TOTAL_SALES FROM USER_CHARACTERISTICS
JOIN SCHEMA_CHARACTERISTICS ON SCHEMA_CHARACTERISTICS.CHARACTERISTIC_ID = USER_CHARACTERISTICS.ID
JOIN PROFILE_CHARACTERISTICS ON PROFILE_CHARACTERISTICS.SCHEMA_CHARACTERISTIC_ID = SCHEMA_CHARACTERISTICS.ID
JOIN PROFILES ON PROFILES.ID = PROFILE_CHARACTERISTICS.PROFILE_ID
JOIN SALES ON SALES.EXECUTOR_PROFILE_ID = PROFILES.ID
WHERE USER_CHARACTERISTICS.ID = 'FED3941A-99A0-4077-880E-A466BE5040C4'
GROUP BY PROFILE_CHARACTERISTICS.CHARACTERISTIC_INFO
```

![](https://i.imgur.com/xRibtGz.png)
### 9.1 LISTA DE CODIGOS DAS FUNÇÕES, ASSERÇOES E TRIGGERS

#### 9.1.1 `AUTH`

Retorna o perfil do cliente caso os dados de entrada (`email` e `password`) sejam válidos. Caso contrário, retorna `null`.
```sql
CREATE OR REPLACE FUNCTION AUTH(EMAIL VARCHAR(256), PASSWORD VARCHAR(512)) RETURNS UUID AS
$$
BEGIN
  RETURN (SELECT PROFILE_ID
          FROM PROFILE_CHARACTERISTICS
                 JOIN SCHEMA_CHARACTERISTICS SC ON PROFILE_CHARACTERISTICS.SCHEMA_CHARACTERISTIC_ID = SC.ID
                 JOIN USER_CHARACTERISTICS UC ON SC.CHARACTERISTIC_ID = UC.ID
                 JOIN PROFILES PROFILE ON PROFILE_CHARACTERISTICS.PROFILE_ID = PROFILE.ID
          WHERE CHARACTERISTIC_INFO = $1
             OR CHARACTERISTIC_INFO = $2
          GROUP BY PROFILE_ID
          HAVING COUNT(*) = 2);
END;
$$ LANGUAGE plpgsql;
```

Exemplo:
```sql
SELECT AUTH('stephen92@frank.com', 'O&HcDIny&3');
```

![](https://i.imgur.com/7C73TO1.png)

### 9.2 GERACAO DE DADOS (MÍNIMO DE 1,5 MILHÃO DE REGISTROS PARA PRINCIPAL RELAÇAO)

| Tabela                    | Quantidade de registros |
| :-----------------------: | :---------------------: |
| `addresses`               | 500                     |
| `cities`                  | 50                      |
| `clients`                 | 500                     |
| `contact_types`           | 1                       |
| `contacts`                | 500                     |
| `invoices`                | 1000000                 |
| `item_categories`         | 1                       |
| `items_stock`             | 1000000                 |
| `payment_methods`         | 2                       |
| `profile_characteristics` | 1500                    |
| `profile_schemas`         | 3                       |
| `profiles`                | 500                     |
| `sales`                   | 1000000                 |
| `schema_characteristics`  | 9                       |
| `states`                  | 10                      |
| `statuses`                | 3                       |
| `user_characteristics`    | 3                       |

### 9.3 BACKUP

![](https://i.imgur.com/ERONqEy.gif)

### 9.4 APLICAÇAO DE ÍNDICES E TESTES DE PERFORMANCE

[Ver arquivo .pdf da apresentação.](https://github.com/savioserra/trab-banco-dados/tree/master/artifacts/slides_performance.pdf)
