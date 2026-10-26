-- Apply in Supabase SQL Editor. Do not expose service_role key.
create extension if not exists pgcrypto;
create table if not exists public.admin_users (user_id uuid primary key references auth.users(id) on delete cascade);
create table if not exists public.products (
 id uuid primary key default gen_random_uuid(), name text not null check(length(name) between 1 and 150),
 category text not null check(length(category) between 1 and 100),
 description text not null default '', image_url text,
 active boolean not null default true, created_at timestamptz not null default now()
);
create table if not exists public.enquiries (
 id uuid primary key default gen_random_uuid(), name text not null check(length(name) between 1 and 120),
 email text not null check(length(email) between 3 and 254),
 phone text not null check(length(phone) between 5 and 25),
 message text not null check(length(message) between 1 and 3000),
 created_at timestamptz not null default now()
);
create index if not exists products_active_idx on public.products(active,created_at desc);
create index if not exists enquiries_created_idx on public.enquiries(created_at desc);
alter table public.admin_users enable row level security;
alter table public.products enable row level security;
alter table public.enquiries enable row level security;
create or replace function public.is_stc_admin() returns boolean language sql stable security definer set search_path = '' as $$
 select exists(select 1 from public.admin_users a where a.user_id = (select auth.uid()))
$$;
revoke all on function public.is_stc_admin() from public;
grant execute on function public.is_stc_admin() to authenticated;
drop policy if exists "admin_self_read" on public.admin_users;
create policy "admin_self_read" on public.admin_users for select to authenticated using (user_id = (select auth.uid()));
drop policy if exists "public_active_products" on public.products;
create policy "public_active_products" on public.products for select to anon,authenticated using (active or public.is_stc_admin());
drop policy if exists "admin_insert_products" on public.products;
create policy "admin_insert_products" on public.products for insert to authenticated with check (public.is_stc_admin());
drop policy if exists "admin_update_products" on public.products;
create policy "admin_update_products" on public.products for update to authenticated using (public.is_stc_admin()) with check(public.is_stc_admin());
drop policy if exists "admin_delete_products" on public.products;
create policy "admin_delete_products" on public.products for delete to authenticated using (public.is_stc_admin());
drop policy if exists "public_submit_enquiry" on public.enquiries;
create policy "public_submit_enquiry" on public.enquiries for insert to anon,authenticated with check(true);
drop policy if exists "admin_read_enquiries" on public.enquiries;
create policy "admin_read_enquiries" on public.enquiries for select to authenticated using(public.is_stc_admin());
-- Manually promote only your trusted account AFTER creating it in Supabase Auth:
-- insert into public.admin_users(user_id) values ('YOUR_AUTH_USER_UUID');
-- Recommended: disable public sign-ups in Auth settings, enable email verification and CAPTCHA.
-- Add rate limiting/CAPTCHA at the edge before using the public enquiry endpoint in production.
