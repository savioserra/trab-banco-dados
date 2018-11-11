# TRABALHO 01 : ÓTICA

Trabalho desenvolvido durante a disciplina de Banco de Dados II.

## SUMÁRIO

- [SUMÁRIO](#sum%C3%A1rio)
- [1 COMPONENTES](#1-componentes)
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
    - [8.1 DETALHAMENTO DAS INFORMAÇÕES](#81-detalhamento-das-informa%C3%A7%C3%B5es)
    - [8.2 SCRIPT PARA CRIAÇÃO DE TABELAS E INSERÇÃO DOS DADOS](#82-script-para-cria%C3%A7%C3%A3o-de-tabelas-e-inser%C3%A7%C3%A3o-dos-dados)

## 1 COMPONENTES

### 1.1 Integrantes do grupo

- Sávio Santos Serra

## 2 INTRODUÇÃO E MOTIVAÇÃO

Através da observação da dificuldade em gerir dados de clientes, pagamentos e vendas em uma ótica, pensou-se em um sistema que facilitasse essa gestão.

## 3 MINI-MUNDO

    A ótica X atualmente realiza o controle de ordens de serviço e pagamentos de clientes manualmente, aspectos esses que mais impactam em sua receita. Contudo, existe uma grande dificuldade para verificar quando uma ordem de serviço foi solicitada, ou quando um pagamento deve ser realizado. Assim, a ótica tem interesse em um sistema que possa automatizar tais interações e extrair relatórios do sistema, como pagamentos a serem recebidos em certo mês, ordens de serviço solicitadas, funcionários mais ativos, receita bruta, entre outros.

    O processo atualmente ocorre da seguinte forma:
        a. Um cliente solicita uma venda. Caso ele já possua ficha no estabelecimento, sua ficha é resgatada; caso contrário, é criada. A venda pode ser sobre vários items, como armações e lentes.

        b. Caso um item seja uma lente, será necessário o envio de uma ordem de serviço para um laboratório para produzir a lente (e montar caso acompanhe a armação). A lente é feita com base em uma receita prescrita por um profissinal oftalmologista.

        c. Uma vez que o laboratório entrega a ordem de serviço, o cliente é notificado e pode buscar o item na loja.

## 4 RASCUNHOS BÁSICOS DA INTERFACE

<Inserir aqui>

## 5 MODELO CONCEITUAL

### 5.1 NOTACAO ENTIDADE RELACIONAMENTO

![Otica](https://i.imgur.com/RYtWGyO.png)

### 5.2 DECISÕES DE PROJETO

    Campos Id: Todos os campos que se referem à `id`s foram implementados utilizando o tipo [`uuid`](https://www.postgresql.org/docs/9.1/datatype-uuid.html). Essa decisão foi tomada para evitar problemas futuros ao realizar merge com réplicas do banco de dados, onde chaves poderiam colidir. Outro motivo por trás dessa decisão é obscurecer a chave primária, uma vez que essa pode ser exposta em um web-service.

    Perfis: Ao invés de herança, foi adotada uma estratégia focada em perfis: uma entidade do sistema possui vários perfis. Perfis possuem tipos (definidos na tabela `profile_schemas`), e seus atributos são representados na tabela `profile_characteristics`. Isso permite que novos atributos possam ser adicionados ou desabilitados sem que a estrutura do banco de dados mude, abrindo mão de performance.

    Itens: No mini-mundo, uma venda é constituida por itens e ordens de serviço. Porém, ordens de serviços também podem conter itens. Optou-se para que a tabela `items_stock` possua ambas as chaves estrangeiras, existindo a possibilidade que o campo `service_id` seja nulo.

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

![ModeloFisico](https://i.imgur.com/14QkrIz.png)

## 8 INSERT APLICADO NAS TABELAS DO BANCO DE DADOS

![Seed](https://i.imgur.com/ydPTiL1.gif)

### 8.1 DETALHAMENTO DAS INFORMAÇÕES

        Detalhamento sobre as informações e processo de obtenção ou geração dos dados.
        Referenciar todas as fontes referentes a:
        a) obtenção dos dados
        b) obtenção de códigos reutilizados
        c) fontes de estudo para desenvolvimento do projeto

### 8.2 SCRIPT PARA CRIAÇÃO DE TABELAS E INSERÇÃO DOS DADOS

    Verificar `create.sql` na pasta artifacts/sql.

## 9 TABELAS E PRINCIPAIS CONSULTAS

### 9.4 LISTA DE CODIGOS DAS FUNÇÕES, ASSERÇOES E TRIGGERS

        Detalhamento sobre funcionalidade de cada código.
        a) Objetivo
        b) Código do objeto (função/trigger/asserção)
        c) exemplo de dados para aplicação
        d) resultados em forma de tabela/imagem

### 9.5 Administração do banco de dados

        Descrição detalhada sobre como serão executadas no banco de dados as
        seguintes atividades.
        a) Segurança e autorização de acesso: especificação básica de configurações de acesso remoto
        b) Estimativas de aquisição de recursos para armazenamento e processamento da informação
        c) Planejamento de rotinas de manutenção e monitoramento do banco
        d) Plano com frequencia de análises visando otimização de performance

### 9.6 GERACAO DE DADOS (MÍNIMO DE 1,5 MILHÃO DE REGISTROS PARA PRINCIPAL RELAÇAO)

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

### 9.7 BACKUP

        Detalhamento do backup.
        a) Tempo
        b) Tamanho
        c) Teste de restauração (backup)
        d) Tempo para restauração
        e) Teste de restauração (script sql)
        f) Tempo para restauração (script sql)

### 9.8 APLICAÇAO DE ÍNDICES E TESTES DE PERFORMANCE

    a) Lista de índices, tipos de índices com explicação de porque foram implementados nas consultas
    b) Performance esperada VS Resultados obtidos
    c) Tabela de resultados comparando velocidades antes e depois da aplicação dos índices (constando velocidade esperada com planejamento, sem indice e com índice Vs velocidade de execucao real com índice e sem índice).
    d) Escolher as consultas mais complexas para serem analisadas (consultas com menos de 2 joins não serão aceitas)
    e) As imagens do Explain devem ser inclusas no trabalho, bem como explicações sobre os resultados obtidos.
    f) Inclusão de tabela mostrando as 10 execuções, excluindo-se o maior e menor tempos para cada consulta e
    obtendo-se a media dos outros valores como resultado médio final.

### 9.9 TRABALHO EM DUPLA - Machine Learning e Data Mining

### Estudar algum dos algoritmos abaixo

### Incluir no trabalho os seguintes tópicos:

- Explicação/Fundamentação teórica sobre o método, objetivos e restrições! (formato doc/odt ou PDF)
- Onde/quando aplicar
  > ##### Estudar e explicar artigo que aplique o método de mineração de dados/machine learning escolhido
- exemplo de uso/aplicação
  > ##### a) Implementar algoritmo de básico de exemplo obtido na literatura (enviar código executável junto do trabalho com detalhamento de explicação para uso passo a passo)
  >
  > ##### b) Aplicar em alguma base de dados aberta (governamental ou sites de datasets disponíveis), registrar e apresentar resultados e algoritmo desenvolvido.

Exemplos de métodos/algoritmos a serem estudados

- "Nearest Neighbors"
- "Linear SVM"
- "RBF SVM"
- "Decision Tree"
- "Random Forest"
- Pca
- "Naive Bayes"

Referência: http://scikit-learn.org/stable/index.html

Referências adicionais:
Scikit learning Map : http://scikit-learn.org/stable/tutorial/machine_learning_map/index.html
Machine learning in Python with scikit-learn: https://www.youtube.com/playlist?list=PL5-da3qGB5ICeMbQuqbbCOQWcS6OYBr5A

## Data de Entrega: (06/12/2018)

## 10 ATUALIZAÇÃO DA DOCUMENTAÇÃO/ SLIDES E ENTREGA FINAL
