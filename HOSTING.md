# Hosting handoff — `preview.v2.kurahealth.ai`

**Goal:** serve the static marketing preview at **https://preview.v2.kurahealth.ai**

**What to deploy:** the `dist/` folder in this directory — a fully static page, **2.6 MB**, no build step, no server-side code.
- `dist/index.html` (entry) + `dist/assets/*.png` (6 product screenshots)
- Single page; no routing/SPA rewrites needed.

Why this is needed from infra: the existing `s3-kura-v2-recordings-user` IAM key is scoped to the
recordings bucket only — it can't create a website bucket, issue a cert, or edit Route 53. So this needs
either (A) someone with broader AWS+DNS access to set it up, or (B) a scoped IAM key handed back so we deploy it.

---

## Option A — AWS S3 + CloudFront (the requested setup)
1. **S3 bucket** (private; e.g. `preview-v2-kurahealth-ai`). Upload `dist/` contents to the root. Block public access ON (CloudFront reads it via OAC).
2. **ACM certificate** for `preview.v2.kurahealth.ai` — **must be in `us-east-1`** (CloudFront requirement). DNS-validate.
3. **CloudFront distribution** — origin = the S3 bucket via **Origin Access Control (OAC)**; default root object = `index.html`; viewer protocol = redirect-to-HTTPS; attach the ACM cert; alternate domain name = `preview.v2.kurahealth.ai`. Add the OAC bucket policy CloudFront generates.
4. **Route 53** (in the `v2.kurahealth.ai` hosted zone): an **A/AAAA alias** record `preview` → the CloudFront distribution.

## Option B — serve from the existing v2 VM (often faster, the box + DNS already exist)
On `v2.kurahealth.ai`'s host: copy `dist/` to `/var/www/preview`, add an nginx server block for
`preview.v2.kurahealth.ai` (root `/var/www/preview`), add the Route 53 record, and issue a cert with
`certbot --nginx -d preview.v2.kurahealth.ai`.

## Option C — hand us a scoped key, we deploy
Provide an IAM key allowed to: `s3:*` on one new bucket, `cloudfront:*`, `acm:*` (us-east-1),
`route53:ChangeResourceRecordSets` on the `v2.kurahealth.ai` zone. We'll run Option A end to end.

---

**Note:** this is a pre-pilot marketing preview (synthetic data only — no PHI). Fine to serve publicly;
optionally gate with basic auth / CloudFront signed URLs if you'd rather keep it unlisted.

**Updating later:** re-upload `dist/` (S3) or rsync it (VM), then invalidate CloudFront (`/*`) if used.
