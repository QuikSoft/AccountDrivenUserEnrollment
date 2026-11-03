# Quiksoft SureMDM – GitHub Pages-only prototype

## Goal
Host the **official SureMDM JSON supplied by the user** at:
`https://adue.quiksoft.nl/.well-known/com.apple.remotemanagement`

The file's content has been copied unchanged from `AccountDrivenUserEnrollment.json`.

## Important: NOT a production-ready Apple ADUE solution

Apple discovers `https://quiksoft.nl/.well-known/com.apple.remotemanagement` for users with managed account identifiers ending `@quiksoft.nl`. For the selected *Option 2*, the root origin needs a **server-side HTTP redirect** to `https://adue.quiksoft.nl/.well-known/com.apple.remotemanagement`, preserving the original `user-identifier` and `model-family` parameters.

**GitHub Pages alone cannot implement a configurable path-specific HTTP 302 redirect.** Browser-based HTML redirects and JavaScript redirects are not substitutes for Apple's HTTP client. GitHub Pages also doesn't provide arbitrary response header configuration, so it cannot guarantee `Content-Type: application/json` for the extensionless discovery document. GitHub Pages automatically redirects only some canonical apex/www combinations; that does not solve this specific route-to-adue requirement.

Therefore this repository is a **prototype to test static delivery**, not an assertion that iOS enrollment will succeed. To implement full Option 2, a capable HTTP redirecting origin is required for the root domain, and the discovery server must return the correct JSON MIME type. The alternative Apple Business Manager fallback for iOS 18.2+ requires MDM-side configuration and is outside the scope of this GitHub-only prototype.

## Deploy the direct endpoint

1. Create a GitHub repository for this site (e.g. `quiksoft-adue`).
2. Upload this repository's **contents**, retaining `.well-known` and `.nojekyll` (hidden files).
3. Open **Settings > Pages** and set deployment to `main` branch, `/ (root)`.
4. Under **Custom domain**, set `adue.quiksoft.nl` and enable **Enforce HTTPS** when available.
5. At your DNS registrar, set `adue` as a CNAME pointing to your GitHub Pages host: `YOUR_GITHUB_USERNAME.github.io` (replace the placeholder). Do not point to `quiksoft.nl`.
6. Test `https://adue.quiksoft.nl/.well-known/com.apple.remotemanagement` and inspect status, MIME type, and JSON body.
7. On a test machine run `bash scripts/check.sh` or the PowerShell commands below.

### Windows PowerShell tests

```powershell
curl.exe -i "https://adue.quiksoft.nl/.well-known/com.apple.remotemanagement?user-identifier=test%40quiksoft.nl&model-family=iPhone"
curl.exe -i --max-redirs 0 "https://quiksoft.nl/.well-known/com.apple.remotemanagement?user-identifier=test%40quiksoft.nl&model-family=iPhone"
```

Expected for real Apple compatibility: `200` and `Content-Type: application/json` at the direct endpoint; `301`/`302` from root with a `Location:` preserving relevant query parameters. **If these tests fail, iOS ADUE should not be expected to work.**

## Official enrollment response

```json
{"Servers":[{"Version":"mdm-byod","BaseURL":"https://quiksoft.eu.suremdm.io/enroll/byod"}]}
```

## References
- Apple: https://developer.apple.com/documentation/devicemanagement/implementing-the-simple-authentication-account-driven-enrollment-flow
- GitHub Pages custom domains: https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/about-custom-domains-and-github-pages
