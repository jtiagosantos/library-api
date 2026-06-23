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

- [ ] Atualizar livro
  - Endpoint: `PATCH /api/v1/books/:id`

---

### Empréstimos

- [ ] Criar empréstimo
  - Endpoint: `POST /api/v1/loans`

- [ ] Devolver livro
  - Endpoint: `PATCH /api/v1/loans/:id/return`

- [ ] Listar empréstimos
  - Endpoint: `GET /api/v1/loans`

- [ ] Buscar empréstimo por id
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

- [ ] O usuário deve existir
- [ ] O livro deve existir
- [ ] O usuário deve estar com status `active`
- [ ] O livro deve possuir ao menos uma cópia disponível
- [ ] O usuário não pode possuir mais de **3 empréstimos ativos**
- [ ] O usuário não pode pegar o mesmo livro duas vezes ao mesmo tempo
- [ ] O usuário não pode criar novo empréstimo se possuir empréstimo vencido em
      aberto

### Ao criar empréstimo

- [ ] Criar registro com:
  - `borrowed_at = now`
  - `due_date = now + 7 dias`
  - `status = active`

- [ ] Decrementar `available_copies` do livro

- [ ] A criação do empréstimo e a atualização do livro devem acontecer em
      **transação**

---

## Devolução

### Regras para devolver livro

- [ ] O empréstimo deve existir
- [ ] O empréstimo não pode estar devolvido

### Ao devolver

- [ ] Preencher `returned_at`
- [ ] Alterar status para `returned`
- [ ] Incrementar `available_copies`

---

## Empréstimos vencidos

- [ ] Se:
  - `due_date < now`
  - `returned_at = nil`

- [ ] Considerar empréstimo como `overdue`

---

# Filtros e listagens

## Listagem de livros

- [ ] Filtrar por título
- [ ] Filtrar por ISBN

### Paginação

- [ ] Suportar:
  - `page`
  - `per_page`

### Ordenação

- [ ] Suportar:
  - `sort=title`
  - `sort=created_at`
  - `sort=published_at`

---

## Listagem de empréstimos

- [ ] Filtrar por usuário
- [ ] Filtrar por livro
- [ ] Filtrar por status

---

# Respostas da API

## Resposta de sucesso

- [ ] Padronizar formato:

```json
{
  "data": {}
}
```
