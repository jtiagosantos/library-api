# API Biblioteca — To-do de implementação

## Casos de uso principais

### Usuários

- [x] Criar usuário
  - Endpoint: `POST /api/v1/users/register`

- [x] Listar usuários
  - Endpoint: `GET /api/v1/users`

- [x] Buscar usuário por id
  - Endpoint: `GET /api/v1/users/:id`

---

### Livros

- [x] Criar livro
  - Endpoint: `POST /api/v1/books`

- [x] Listar livros
  - Endpoint: `GET /api/v1/books`

- [x] Buscar livro por id
  - Endpoint: `GET /api/v1/books/:id`

- [x] Atualizar livro
  - Endpoint: `PATCH /api/v1/books/:id`

---

### Empréstimos

- [x] Criar empréstimo
  - Endpoint: `POST /api/v1/loans`

- [x] Devolver livro
  - Endpoint: `PATCH /api/v1/loans/:id/return`

- [x] Listar empréstimos
  - Endpoint: `GET /api/v1/loans`

- [x] Buscar empréstimo por id
  - Endpoint: `GET /api/v1/loans/:id`

---

# Regras de negócio

## Usuários

- [x] O email deve ser obrigatório
- [x] O nome deve ser obrigatório
- [x] O email deve ser único
- [x] O usuário deve possuir status
  - valores permitidos:
    - `active`
    - `blocked`

---

## Livros

- [x] O título deve ser obrigatório
- [x] O ISBN deve ser obrigatório
- [x] O ISBN deve ser único
- [x] `total_copies` deve ser maior que zero
- [x] `available_copies` não pode ser negativo
- [x] `available_copies` não pode ser maior que `total_copies`

---

## Empréstimos

### Regras para criar empréstimo

- [x] O usuário deve existir
- [x] O livro deve existir
- [x] O usuário deve estar com status `active`
- [x] O livro deve possuir ao menos uma cópia disponível
- [x] O usuário não pode possuir mais de **3 empréstimos ativos**
- [x] O usuário não pode pegar o mesmo livro duas vezes ao mesmo tempo
- [x] O usuário não pode criar novo empréstimo se possuir empréstimo vencido em
      aberto

### Ao criar empréstimo

- [x] Criar registro com:
  - `borrowed_at = now`
  - `due_date = now + 7 dias`
  - `status = active`

- [x] Decrementar `available_copies` do livro

- [x] A criação do empréstimo e a atualização do livro devem acontecer em
      **transação**

---

## Devolução

### Regras para devolver livro

- [x] O empréstimo deve existir
- [x] O empréstimo não pode estar devolvido

### Ao devolver

- [x] Preencher `returned_at`
- [x] Alterar status para `returned`
- [x] Incrementar `available_copies`

---

## Empréstimos vencidos

- [x] Se:
  - `due_date < now`
  - `returned_at = nil`

- [x] Considerar empréstimo como `overdue`

---

# Filtros e listagens

## Listagem de livros

- [x] Filtrar por título
- [x] Filtrar por ISBN

### Paginação

- [x] Suportar:
  - `page`
  - `per_page`

### Ordenação

- [x] Suportar:
  - `sort=title`
  - `sort=created_at`
  - `sort=published_at`

---

## Listagem de empréstimos

- [x] Filtrar por usuário
- [x] Filtrar por livro
- [x] Filtrar por status

---

# Respostas da API

## Resposta de sucesso

- [ ] Padronizar formato:

```json
{
  "data": {},
  "errors": [],
  "metadata": {}
}
```
