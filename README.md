# STC Safety website

A responsive, static starter storefront for STC Safety with a **local-only admin UI prototype**.

## Preview
Open `index.html` in a browser or deploy the repository to a static host (GitHub Pages, Netlify, etc.). Open `admin.html` to view the admin prototype.

## Important limitations
- **The admin is not secure or production-ready.** It has no authentication, server, database or authorization.
- Products added in admin are stored in browser localStorage only and **do not change the storefront**.
- The enquiry form opens the visitor's email app, but **no recipient address has been configured**. It does not submit to a server or capture leads.
- Product categories and featured items are illustrative starter content; confirm product data, prices, logos and compliance claims before publishing.
- Brand names are text placeholders and do not imply endorsement or certification.
- A production build needs authenticated admin routes, a backend, persistent product/media storage, an enquiry API, spam protection and deployment configuration.

## Suggested production architecture
Next.js storefront + authenticated admin; PostgreSQL with Prisma; object storage for images; role-based access; server-side validation and audit logging. Deploy to a provider supporting server-side routes. Keep secrets out of Git.

## Files
- `index.html` public storefront
- `styles.css` responsive design
- `app.js` public category/product samples and email handoff
- `admin.html` demo dashboard
- `admin.js` local-only demo product manager
