# TRABALHO 01 : ÓTICA
Trabalho desenvolvido durante a disciplina de Banco de Dados II.

## SUMÁRIO
- [1 COMPONENTES](#1componentes)
- [2 INTRODUÇÃO E MOTIVAÇÃO](#2introduÇÃo-e-motivaÇÃo)
- [3 MINI-MUNDO](#3mini-mundo)
- [4 RASCUNHOS BÁSICOS DA INTERFACE](#4rascunhos-bÁsicos-da-interface)
- [5 MODELO CONCEITUAL](#5modelo-conceitual)
- [6 MODELO LÓGICO](#6modelo-lÓgico)
- [7 MODELO FÍSICO](#7modelo-fÍsico)
- [8 INSERT APLICADO NAS TABELAS DO BANCO DE DADOS](#8insert-aplicado-nas-tabelas-do-banco-de-dados)
- [9 TABELAS E PRINCIPAIS CONSULTAS](#9tabelas-e-principais-consultas)

## 1	COMPONENTES
### 1.1 Integrantes do grupo
- Sávio Santos Serra

## 2	INTRODUÇÃO E MOTIVAÇÃO
Através da observação da dificuldade em gerir dados de clientes, pagamentos e vendas em uma ótica, pensou-se em um sistema que facilitasse essa gestão.

## 3	MINI-MUNDO
    A ótica X atualmente realiza o controle de ordens de serviço e pagamentos de clientes manualmente, aspectos esses que mais impactam em sua receita. Contudo, existe uma grande dificuldade para verificar quando uma ordem de serviço foi solicitada, ou quando um pagamento deve ser realizado. Assim, a ótica tem interesse em um sistema que possa automatizar tais interações e extrair relatórios do sistema, como pagamentos a serem recebidos em certo mês, ordens de serviço solicitadas, funcionários mais ativos, receita bruta, entre outros.

    O processo atualmente ocorre da seguinte forma:
        a. Um cliente solicita uma venda. Caso ele já possua ficha no estabelecimento, sua ficha é resgatada; caso contrário, é criada. A venda pode ser sobre vários items, como armações e lentes.

        b. Caso um item seja uma lente, será necessário o envio de uma ordem de serviço para um laboratório para produzir a lente (e montar caso acompanhe a armação). A lente é feita com base em uma receita prescrita por um profissinal oftalmologista.

        c. Uma vez que o laboratório entrega a ordem de serviço, o cliente é notificado e pode buscar o item na loja.

## 4	RASCUNHOS BÁSICOS DA INTERFACE
<Inserir aqui>

## 5	MODELO CONCEITUAL
### 5.1 NOTACAO ENTIDADE RELACIONAMENTO
![Otica](https://i.imgur.com/RYtWGyO.png)
    
### 5.2 DECISÕES DE PROJETO
    [atributo]: [descrição da decisão]
    
    EXEMPLO:
    a) Campo endereço: em nosso projeto optamos por um campo multivalorado e composto, pois a empresa 
    pode possuir para cada departamento mais de uma localização... 
    b) justifique!

### 5.3 DESCRIÇÃO DOS DADOS 
    [objeto]: [descrição do objeto]
    
    EXEMPLO:
    CLIENTE: Tabela que armazena as informações relativas ao cliente
    CPF: campo que armazena o número de Cadastro de Pessoa Física para cada cliente da empresa.

## 6	MODELO LÓGICO

## 7	MODELO FÍSICO

## 8	INSERT APLICADO NAS TABELAS DO BANCO DE DADOS
### 8.1 DETALHAMENTO DAS INFORMAÇÕES
        Detalhamento sobre as informações e processo de obtenção ou geração dos dados.
        Referenciar todas as fontes referentes a:
        a) obtenção dos dados
        b) obtenção de códigos reutilizados
        c) fontes de estudo para desenvolvimento do projeto
        
### 8.2 INCLUSÃO DO SCRIPT PARA CRIAÇÃO DE TABELAS E INSERÇÃO DOS DADOS (ARQUIVO ÚNICO COM):
        a) inclusão das instruções para criação das tabelas e estruturas de amazenamento do BD
        b) inclusão das instruções de inserção dos dados nas referidas tabelas
        c) inclusão das instruções para execução de outros procedimentos necessários

## 9	TABELAS E PRINCIPAIS CONSULTAS
### 9.1	GERACAO DE DADOS (MÍNIMO DE 10 REGISTROS PARA CADA TABELA NO BANCO DE DADOS)

## Data de Entrega: (06/09/2018)
OBS: Incluir para os tópicos 9.2 e 9.3 as instruções SQL + imagens (print da tela) mostrando os resultados.

### 9.2	SELECT DAS TABELAS COM PRIMEIROS 10 REGISTROS INSERIDOS

### 9.3	SELECT DAS VISÕES COM PRIMEIROS 10 REGISTROS DA VIEW
        a) Descrição da view sobre que grupos de usuários (operacional/estratégico) 
        e necessidade ela contempla.
        b) Descrição das permissões de acesso e usuários correlacionados (após definição 
        destas características)
        c) as funcionalidades informadas no minimundo ou nos mockups(protótipos), que representarem 
        views do sistema (relatórios, informações disponíveis para os usuários, etc) devem estar 
        presentes aqui. 

### 9.4	LISTA DE CODIGOS DAS FUNÇÕES, ASSERÇOES E TRIGGERS
        Detalhamento sobre funcionalidade de cada código.
        a) Objetivo
        b) Código do objeto (função/trigger/asserção)
        c) exemplo de dados para aplicação
        d) resultados em forma de tabela/imagem

## Data de Entrega: (27/09/2018)

### 9.5	Administração do banco de dados
        Descrição detalhada sobre como serão executadas no banco de dados as 
        seguintes atividades.
        a) Segurança e autorização de acesso: especificação básica de configurações de acesso remoto
        b) Estimativas de aquisição de recursos para armazenamento e processamento da informação
        c) Planejamento de rotinas de manutenção e monitoramento do banco
        d) Plano com frequencia de análises visando otimização de performance

### 9.6	GERACAO DE DADOS (MÍNIMO DE 1,5 MILHÃO DE REGISTROS PARA PRINCIPAL RELAÇAO)
        a) principal tabela do sistema deve ter no mínimo 1,5 milhão de registros
        b) tabelas diretamente relacionadas a tabela principal 100 mil registros
        c) tabelas auxiliares de relacao multivalorada mínimo de 10 registros
        d) registrar o tempo de inserção em cada uma das tabelas do banco de dados
        e) especificar a quantidade de registros inseridos em cada tabela
        Para melhor compreensão verifiquem o exemplo na base de testes:
        https://github.com/discipbd2/base-de-testes-locadora
        
## Data de Entrega: (31/10/2018)

### 9.7	Backup do Banco de Dados
        Detalhamento do backup.
        a) Tempo
        b) Tamanho
        c) Teste de restauração (backup)
        d) Tempo para restauração
        e) Teste de restauração (script sql)
        f) Tempo para restauração (script sql)

### 9.8	APLICAÇAO DE ÍNDICES E TESTES DE PERFORMANCE
    a) Lista de índices, tipos de índices com explicação de porque foram implementados nas consultas 
    b) Performance esperada VS Resultados obtidos
    c) Tabela de resultados comparando velocidades antes e depois da aplicação dos índices (constando velocidade esperada com planejamento, sem indice e com índice Vs velocidade de execucao real com índice e sem índice).
    d) Escolher as consultas mais complexas para serem analisadas (consultas com menos de 2 joins não serão aceitas)
    e) As imagens do Explain devem ser inclusas no trabalho, bem como explicações sobre os resultados obtidos.
    f) Inclusão de tabela mostrando as 10 execuções, excluindo-se o maior e menor tempos para cada consulta e 
    obtendo-se a media dos outros valores como resultado médio final.

## Data de Entrega: (22/11/2018)

### 9.9 TRABALHO EM DUPLA - Machine Learning e Data Mining
### Estudar algum dos algoritmos abaixo
### Incluir no trabalho os seguintes tópicos: 
* Explicação/Fundamentação teórica sobre o método, objetivos e restrições! (formato doc/odt ou PDF)
* Onde/quando aplicar 
> ##### Estudar e explicar artigo que aplique o método de mineração de dados/machine learning escolhido
* exemplo de uso/aplicação 
> ##### a) Implementar algoritmo de básico de exemplo obtido na literatura (enviar código executável junto do trabalho com detalhamento de explicação para uso passo a passo)
> #####  b) Aplicar em alguma base de dados aberta (governamental ou sites de datasets disponíveis), registrar e apresentar resultados e algoritmo desenvolvido.

Exemplos de métodos/algoritmos a serem estudados
* "Nearest Neighbors" 
* "Linear SVM" 
* "RBF SVM" 
* "Decision Tree" 
* "Random Forest"
* Pca  
* "Naive Bayes"

Referência: http://scikit-learn.org/stable/index.html

Referências adicionais:
Scikit learning Map : http://scikit-learn.org/stable/tutorial/machine_learning_map/index.html
Machine learning in Python with scikit-learn: https://www.youtube.com/playlist?list=PL5-da3qGB5ICeMbQuqbbCOQWcS6OYBr5A

## Data de Entrega: (06/12/2018)

## 10	ATUALIZAÇÃO DA DOCUMENTAÇÃO/ SLIDES E ENTREGA FINAL

### OBSERVAÇÕES
Link para BrModelo: 
* http://sis4.com/brModelo/brModelo/download.html