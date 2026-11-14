-- Tempo: estrutura da base de dados (correr uma vez no SQL Editor do Supabase)

-- 1. Tabelas -----------------------------------------------------------------

create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  nome text not null default '',
  created_at timestamptz not null default now()
);

create table public.items (
  id text primary key,
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  doc jsonb not null,
  updated_at timestamptz not null default now()
);
create index items_user_idx on public.items (user_id);

create table public.notas (
  id text primary key,
  user_id uuid not null default auth.uid() references auth.users (id) on delete cascade,
  doc jsonb not null,
  updated_at timestamptz not null default now()
);
create index notas_user_idx on public.notas (user_id);

create table public.messages (
  id bigint generated always as identity primary key,
  sender uuid not null default auth.uid() references auth.users (id) on delete cascade,
  recipient uuid not null references auth.users (id) on delete cascade,
  body text not null check (char_length(body) between 1 and 2000),
  created_at timestamptz not null default now(),
  check (sender <> recipient)
);
create index messages_sender_idx on public.messages (sender, created_at);
create index messages_recipient_idx on public.messages (recipient, created_at);

-- 2. Regras de acesso: cada pessoa só vê o que é seu ---------------------------

alter table public.profiles enable row level security;
alter table public.items enable row level security;
alter table public.notas enable row level security;
alter table public.messages enable row level security;

create policy "ver nomes" on public.profiles
  for select to authenticated using (true);
create policy "mudar o proprio nome" on public.profiles
  for update to authenticated using (id = (select auth.uid())) with check (id = (select auth.uid()));

create policy "os meus itens" on public.items
  for all to authenticated using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

create policy "as minhas notas" on public.notas
  for all to authenticated using (user_id = (select auth.uid())) with check (user_id = (select auth.uid()));

create policy "ler as minhas conversas" on public.messages
  for select to authenticated using (sender = (select auth.uid()) or recipient = (select auth.uid()));
create policy "enviar em meu nome" on public.messages
  for insert to authenticated with check (sender = (select auth.uid()));

-- 3. Criar o perfil quando alguém cria conta ----------------------------------

create function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
  insert into public.profiles (id, nome)
  values (new.id, coalesce(nullif(new.raw_user_meta_data ->> 'nome', ''), split_part(new.email, '@', 1)));
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- 4. Procurar uma pessoa pelo email exato (sem expor a lista de emails) --------

create function public.find_user(p_email text) returns table (id uuid, nome text)
language sql stable security definer set search_path = '' as $$
  select p.id, p.nome
  from auth.users u join public.profiles p on p.id = u.id
  where lower(u.email) = lower(trim(p_email))
  limit 1;
$$;
revoke execute on function public.find_user(text) from public, anon;
grant execute on function public.find_user(text) to authenticated;
revoke execute on function public.handle_new_user() from public, anon, authenticated;

-- 5. Tempo real: avisar o site quando há dados novos --------------------------

alter publication supabase_realtime add table public.items, public.notas, public.messages;
