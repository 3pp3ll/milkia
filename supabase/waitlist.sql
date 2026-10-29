-- مِلْكية — قائمة الاهتمام (المرحلة الأولى من الربط)
-- تنشغّل في مشروع Supabase حق «عقود» (oqood) ← SQL Editor ← New query ← Run. آمن لإعادة التشغيل.
-- أي زائر يقدر يسجّل اهتمامه، وما يقدر يقرأ القائمة إلا المالك.

create table if not exists public.milkia_waitlist (
  id bigserial primary key,
  name text not null check (length(name) between 2 and 80),
  email text not null check (email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$' and length(email) <= 120),
  phone text not null check (phone ~ '^[0-9+ ]{9,16}$'),
  role text not null check (role in ('seller','buyer','advisor')),
  consent boolean not null default false check (consent),
  created_at timestamptz not null default now()
);
create unique index if not exists milkia_waitlist_email on public.milkia_waitlist (lower(email));

alter table public.milkia_waitlist enable row level security;
drop policy if exists "milkia waitlist insert" on public.milkia_waitlist;
create policy "milkia waitlist insert" on public.milkia_waitlist for insert to anon, authenticated with check (true);
drop policy if exists "milkia waitlist admin" on public.milkia_waitlist;
create policy "milkia waitlist admin" on public.milkia_waitlist for select using (public.is_admin());
drop policy if exists "milkia waitlist admin del" on public.milkia_waitlist;
create policy "milkia waitlist admin del" on public.milkia_waitlist for delete using (public.is_admin());

grant insert on public.milkia_waitlist to anon, authenticated;
grant select, delete on public.milkia_waitlist to authenticated;
grant usage, select on sequence public.milkia_waitlist_id_seq to anon, authenticated;
