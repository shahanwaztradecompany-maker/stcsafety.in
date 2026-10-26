# STC Safety Website and Admin

Static frontend with Supabase-backed product catalogue, customer enquiries, and authenticated admin dashboard.

## Setup (required before live use)
1. Create a Supabase project at https://supabase.com/dashboard.
2. Open SQL Editor and execute `supabase/schema.sql`.
3. In Supabase Auth, create an admin user. Enable email verification, disable public signup, and configure your site's URLs.
4. Find the new user's UUID under Authentication > Users. In SQL Editor, run:
   `insert into public.admin_users(user_id) values ('YOUR_AUTH_USER_UUID');`
5. Copy your Supabase project URL and **publishable/anon** key into `config.js`. Never commit the service_role key or other secret credentials.
6. Deploy to an HTTPS static host (GitHub Pages works for this frontend). Configure allowed Auth site URLs for your domain.
7. Sign in at `/admin.html`. Admins can create and delete products and read enquiries. New active products appear in the public catalogue.

## Security and launch checklist
- Supabase Row Level Security is enabled for all three tables; only allowlisted auth users can modify products or read enquiries.
- The admin HTML page itself is public, but its data operations are protected by Supabase Auth + RLS. The admin user must be created and allowlisted manually.
- The public enquiry insert endpoint is **not rate-limited** by this app. Add a CAPTCHA/Turnstile-verified server-side endpoint, spam throttling, monitoring and privacy/consent language **before** launching publicly. Avoid collecting personal data until this is complete.
- Product image URLs must be hosted externally via HTTPS. Upload support and editing existing products are not implemented yet.
- Verify all product specifications, brands, certifications and images before publishing.
- Without Supabase configuration, the public page shows sample products; the enquiry form does not submit and admin sign-in is unavailable.
- Do not consider this production-ready until deployment, security checks, testing and spam protection are completed.

## Structure
- `index.html`, `styles.css`, `app.js`: public storefront
- `admin.html`, `admin.js`: authenticated product/enquiry dashboard
- `config.js`, `db.js`: browser Supabase connection
- `supabase/schema.sql`: database and RLS policies
