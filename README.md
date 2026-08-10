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

## Sharing — what actually works
- **HTML attachment:** ❌ blank images on iPhone Mail (data: URIs stripped).
- **PDF attachment:** ⚠ works but ugly (one giant page).
- **Hosted link:** ✅ the right answer. Decided: **S3 hosting at `preview.v2.kurahealth.ai`**. Blocked on Austin
  (the local AWS key is recordings-scoped only — no bucket/CloudFront/ACM/Route53). `HOSTING.md` is the ask.
  Interim option: **Netlify Drop** (drag `dist/` to app.netlify.com/drop) → instant link, no creds.

## To regenerate after editing index.html
- Self-contained: re-run the base64 inline (resize via `sips --resampleWidth 1600` into /tmp/inl, then inline).
- Verify renders headless on :PORT and at iPhone width (390px) — see how the decks were verified.

## Next step
Production **Next.js port** (responsive, working "Get a demo" form, SEO, deploy) once the design is approved
and the team's feedback is in. The clinician-deck + investor-deck PDFs live in `kurahealth-v2/demo/pdf/`.
