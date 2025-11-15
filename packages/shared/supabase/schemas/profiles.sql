create table if not exists public."profiles"(
    id uuid not null,
    language public."Language" not null default 'vi'::"Language",
    cloud_sync_enabled boolean not null default false,
    created_at timestamp with time zone not null default now(),
    updated_at timestamp with time zone not null default now(),

    constraint profiles_pkey primary key(id),
    constraint profiles_id_fkey foreign key(id)
    references auth.users(id) on update cascade on delete cascade
) tablespace pg_default;

create policy "Users can only view their own profiles"
on public."profiles" for select
using ((select auth.uid() as uid) = id);

alter table public."profiles" enable row level security;
