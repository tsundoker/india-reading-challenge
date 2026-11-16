-- Run this entire script in Supabase Dashboard > SQL Editor.
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default 'Reader',
  created_at timestamptz not null default now()
);
create table if not exists public.books (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  state text not null,
  title text not null check (char_length(trim(title)) between 1 and 250),
  author text not null default '',
  created_at timestamptz not null default now()
);
create index if not exists books_user_id_idx on public.books(user_id);
create index if not exists books_state_idx on public.books(state);
alter table public.profiles enable row level security;
alter table public.books enable row level security;
drop policy if exists "Profiles are public to read" on public.profiles;
create policy "Profiles are public to read" on public.profiles for select using (true);
drop policy if exists "Users can create own profile" on public.profiles;
create policy "Users can create own profile" on public.profiles for insert with check (auth.uid() = id);
drop policy if exists "Users can update own profile" on public.profiles;
create policy "Users can update own profile" on public.profiles for update using (auth.uid() = id) with check (auth.uid() = id);
drop policy if exists "Books are public to read" on public.books;
create policy "Books are public to read" on public.books for select using (true);
drop policy if exists "Users can add own books" on public.books;
create policy "Users can add own books" on public.books for insert with check (auth.uid() = user_id);
drop policy if exists "Users can edit own books" on public.books;
create policy "Users can edit own books" on public.books for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
drop policy if exists "Users can delete own books" on public.books;
create policy "Users can delete own books" on public.books for delete using (auth.uid() = user_id);
-- Automatically create a public profile row at signup.
create or replace function public.handle_new_user() returns trigger
language plpgsql security definer set search_path = '' as $$
begin
  insert into public.profiles (id, display_name)
  values (new.id, coalesce(nullif(new.raw_user_meta_data ->> 'display_name',''), split_part(new.email,'@',1)));
  return new;
end;
$$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users
for each row execute procedure public.handle_new_user();
