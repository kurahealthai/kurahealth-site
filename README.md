# KuraHealth marketing site (preview)

Status as of **2026-06-29**. Built this session for investor/team sharing — a world-class, light-&-clinical,
product-led marketing page built around real V2 product screenshots. **Not yet in version control** (the parent
`/Users/msaa/KuraHealth` is not a git repo); files live on disk here and survive a reboot.

## Tagline / positioning (decided, research-grounded — see kurahealth-v2/docs/DECK-STRATEGY.md §4)
- **Tagline:** **"Every chart — paid and audit-ready."**
- **Identity:** *"The compliance brain for behavioral health."*
- **Heart:** *"So your clinicians can focus on what matters — care."* (a purpose, not an outcome claim — we're pre-pilot)

## Files
| File | What it is |
|---|---|
| `index.html` | **The source page.** Self-contained CSS + scroll-reveal; references `assets/*.png`. Open in a desktop browser. Mobile layer added (≤560px) incl. swipe-legible product screenshots + iOS `-webkit-backdrop-filter`. |
| `assets/` | Full-res clean-white product screenshots (copied from `kurahealth-v2/demo/shots/`). |
| `dist/` | **Clean deploy folder** (index.html + only the 6 referenced PNGs, 2.6 MB). This is what gets hosted. |
| `KuraHealth.html` | Self-contained single file (images base64-inlined). **⚠ Do NOT email** — iOS Mail strips `data:` images (renders blank on iPhone). OK for desktop-browser open. |
| `KuraHealth-preview.pdf` | One-page PDF export (shadows removed to avoid Quartz grey-blocks). Renders on iPhone Mail but is a tall single page — founder found it "terrible." Avoid. |
| `HOSTING.md` | **Handoff for Austin** to host `dist/` at `preview.v2.kurahealth.ai`. |

## Where it lives now (2026-08-10)

| | |
|---|---|
| **Preview URL** | `https://new.kurahealth.ai/u6ts1tC3vq9i/ovQAJASHSGeLuS/` |
| **Also on** | GitHub Pages: `kurahealthai.github.io/kurahealth-site` (repo `kurahealthai/kurahealth-site`) |
| **Deploy** | `./deploy.sh` — uploads `dist/` and invalidates the CDN |

**Why the unguessable path and not `preview.v2.kurahealth.ai`** (Austin's call): a DNS name is an
announcement — every TLS certificate is published to certificate-transparency logs, and subdomain
scanners follow. A nested path under an existing certificate leaks nowhere, and candidates can sit
side by side for comparison. **It is obscurity, not authentication** — anyone with the link can
read the page, so it stays synthetic-only and off public channels.

**The deploy trap:** the bucket serves objects by their individual ACLs. An upload without
`--acl public-read` *succeeds* and then serves 403. `deploy.sh` always passes it; don't remove it.
Cache is up to 24h, so the invalidation step is not optional.

**If you see a CloudFront "403 Request blocked"** that is the WAF, not the site — try without a VPN.


## To regenerate after editing index.html
- Self-contained: re-run the base64 inline (resize via `sips --resampleWidth 1600` into /tmp/inl, then inline).
- Verify renders headless on :PORT and at iPhone width (390px) — see how the decks were verified.

## Next step
Production **Next.js port** (responsive, working "Get a demo" form, SEO, deploy) once the design is approved
and the team's feedback is in. The clinician-deck + investor-deck PDFs live in `kurahealth-v2/demo/pdf/`.
