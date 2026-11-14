# Tempo — versão web de testes

Agenda (tarefas, trabalhos, testes, notas) com contas e um chat de mensagens diretas.

## Ficheiros

- `index.html` — o site inteiro (desenho e lógica).
- `config.js` — os dois dados que ligam o site à base de dados Supabase.
- `supabase/schema.sql` — a estrutura da base de dados. Corre-se uma vez no SQL Editor do Supabase.

## Pôr a funcionar

1. Supabase: cria um projeto, abre o SQL Editor, cola o conteúdo de `supabase/schema.sql` e carrega em Run.
2. Supabase: em Authentication, desliga "Confirm email" enquanto estiveres em testes.
3. Copia o Project URL e a chave publishable para `config.js`.
4. GitHub: cria um repositório, carrega estes ficheiros e ativa o GitHub Pages (Settings > Pages > branch `main`).

Sem preencher `config.js`, o site abre em modo de demonstração: os dados ficam só no browser e o chat fica desligado.

## Segurança

A chave publishable pode estar no repositório: quem protege os dados são as regras de acesso em `schema.sql`.
A chave secret / service_role nunca entra neste repositório.
