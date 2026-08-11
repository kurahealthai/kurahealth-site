#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# Deploy the marketing site to its stealth preview URL (Austin, 2026-08-10).
#
#   https://new.kurahealth.ai/u6ts1tC3vq9i/ovQAJASHSGeLuS/
#
# Why the unguessable path rather than preview.v2.kurahealth.ai: a DNS name is an
# announcement — every TLS cert is published to certificate-transparency logs and
# subdomain scanners follow. A nested path under an existing cert leaks nowhere.
# It is OBSCURITY, NOT AUTHENTICATION: anyone with the link can read the page.
# Synthetic marketing content only; never post the link publicly.
#
#   ./deploy.sh
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail
cd "$(dirname "$0")"

BUCKET="s3://new-frontpage/u6ts1tC3vq9i/ovQAJASHSGeLuS/"
DIST_ID="E2EGRC2KBYDB6C"
INVALIDATE="/u6ts1tC3vq9i/*"
PROFILE="${AWS_PROFILE:-kurahealth-v2}"

# Keep dist/ identical to the source page before shipping — dist IS what gets served.
cp index.html dist/index.html
mkdir -p dist/assets
for f in assets/v2-*.png; do [ -e "$f" ] && cp "$f" dist/assets/; done

echo "── uploading dist/ → $BUCKET"
# THE TRAP (Austin): this bucket serves objects via their INDIVIDUAL ACLs. An upload
# without --acl public-read SUCCEEDS and then serves 403 through the site. If a deploy
# "worked" but the page is broken, this flag is why. Never remove it.
aws s3 cp dist/ "$BUCKET" --recursive --acl public-read --profile "$PROFILE"

echo "── invalidating the CDN cache"
# Pages are cached up to 24h. Without this the deploy silently does not appear until tomorrow.
aws cloudfront create-invalidation --profile "$PROFILE" \
  --distribution-id "$DIST_ID" --paths "$INVALIDATE" \
  --query 'Invalidation.{Id:Id,Status:Status}' --output text

echo "── deployed. Allow a minute for the invalidation, then check:"
echo "   https://new.kurahealth.ai/u6ts1tC3vq9i/ovQAJASHSGeLuS/"
echo
echo "NOTE: if you get a CloudFront '403 Request blocked', that is the WAF — try without a VPN."
