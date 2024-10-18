# Sistema de Pedidos de Venda

## Descrição do Projeto

Este projeto foi desenvolvido como parte do teste técnico para a vaga de Desenvolvedor Delphi na WK Technology. O sistema permite a criação e gerenciamento de pedidos de venda, utilizando conceitos de Programação Orientada a Objetos (POO), o padrão Model-View-Controller (MVC) e práticas de Clean Code.

## Funcionalidades

1. **Cadastro de Clientes e Produtos:** Permite ao operador informar clientes e produtos (não foi desenvolvido o cadastro).
2. **Tela de Pedidos:** O operador pode informar produtos com código, quantidade e valor unitário, que são exibidos em um grid.
3. **Grid Interativo:** O grid apresenta informações como código do produto, descrição, quantidade, valor unitário e total. Permite navegação e edição.
4. **Ações no Grid:**
   - **Inserir Produtos:** Adiciona produtos ao pedido.
   - **Alterar Produtos:** Permite alteração da quantidade e valor unitário.
   - **Remover Produtos:** Possibilita a exclusão de produtos, com confirmação.
5. **Resumo do Pedido:** Exibe o valor total do pedido no rodapé da tela.
6. **Gravação de Pedidos:** Armazena os dados gerais do pedido e produtos em duas tabelas distintas.
7. **Carregamento de Pedidos:** Possibilita carregar pedidos já gravados quando o código do cliente estiver em branco.
8. **Cancelamento de Pedidos:** Permite a exclusão de pedidos existentes.
9. **Configuração Dinâmica:** Acesso ao banco de dados configurado através de um arquivo `.ini`.

## Estrutura do Banco de Dados

O banco de dados foi implementado utilizando MySQL, com as seguintes tabelas:

- **Cliente:** Armazena dados dos clientes (CODIGO, NOME, CIDADE, UF).
- **Produto:** Armazena dados dos produtos (CODIGO, DESCRICAO, PRVDA).
- **Pedidos:** Contém os dados gerais dos pedidos (NUMERO, DTEMISS, CLIENTE, VLRTOT).
- **Produtos do Pedido:** Armazena os itens do pedido (ORDEM, PEDIDO, PRODUTO, QTDE, VLRUNIT, VLRTOT).

## Tecnologias Utilizadas

- **Delphi:** Para desenvolvimento da aplicação.
- **FireDAC:** Para acesso ao banco de dados.
- **MySQL:** Como sistema de gerenciamento de banco de dados.

## Instruções de Uso

1. **Configuração do Banco de Dados:**
   - Crie as tabelas no MySQL conforme os scripts fornecidos no DUMP (dump.sql).
   - Configure as informações de conexão no arquivo `config.ini`.

2. **Execução do Sistema:**
   - Compile e execute o projeto no Delphi.
   - Utilize a interface para registrar e gerenciar pedidos de venda.

## Documentação

A documentação técnica foi realizada através de diagramas de entidades e relacionamentos, bem como diagramas de classes (UML). Estes documentos estão disponíveis no diretório `/docs`.

## Contribuições

Este projeto é uma demonstração das habilidades técnicas de desenvolvimento em Delphi e não é um produto final.

## Licença

Este projeto está sob a Licença MIT.

---

Agradeço pela oportunidade de participar do processo seletivo!