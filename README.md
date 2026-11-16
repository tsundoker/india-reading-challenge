# India Reading Challenge — community edition

This static HTML/CSS/JS site is connected to the supplied Supabase project. It keeps the India map artwork and supports email/password accounts, shared public book lists, and a community leaderboard. Each participant can add multiple books to each state/UT.

## Supabase connection

`config.js` is already configured with the Project URL and publishable key supplied by the project owner. The URL is normalized to the project root (`https://hweyyxnnzvpizuymkvog.supabase.co`); do not append `/rest/v1/` when calling `createClient`.

The publishable key is intended for browser use. Never put a Supabase secret or service-role key in this folder or in a public repository.

## Database

The owner has already run `supabase-schema.sql` in Supabase SQL Editor. It creates the `profiles` and `books` tables, public read policies, per-user write policies, and a signup trigger that creates public display names.

## Preview locally

Serve this folder with a static web server, e.g. `python3 -m http.server 8000`, then open http://localhost:8000. Opening `index.html` directly as a `file://` URL may cause browser restrictions.

## Publish free with Cloudflare Pages

1. Create a GitHub repository and upload all files in this folder, including `config.js` and `index.html`.
2. In Cloudflare Dashboard, go to **Workers & Pages → Create → Pages → Connect to Git** and select the repository.
3. Choose **None** as the framework preset, leave the build command blank, and set the output directory to `/` (or repository root, depending on the UI).
4. Deploy. Cloudflare will provide a `*.pages.dev` address.
5. In Supabase **Authentication → URL Configuration**, set **Site URL** to that deployed address and add it to **Redirect URLs**.

## Privacy and permissions

- Everyone can read book entries and public display names.
- Signed-in participants can create, edit, and delete only their own book rows; Row Level Security enforces this.
- Email addresses are held by Supabase Auth and are not selected or displayed by this site.
- Anyone can register. Consider enabling email confirmation and CAPTCHA/rate limits before widely sharing the site.

## Notes

- Multiple books per state/UT are supported. Map progress counts distinct states/UTs covered; the total book count is shown separately.
- The map boundaries are simplified from the original supplied page.
- Supabase free projects may pause after inactivity; check current plan limits before relying on it for a long-running community.
