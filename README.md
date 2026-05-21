# 2004lryan.github.io

Source for https://2004lryan.github.io —— personal homepage of 李盼林 (Ryan Lin).

Hand-crafted static HTML/CSS, no build step. Bilingual EN/中 toggle. Password-protected "Others" page.

## Files

| File | Purpose |
|------|---------|
| `index.html` | main page (About / News / Publications / CV / Contact) |
| `others.html` | password-protected page (AES-256-GCM encrypted) |
| `style.css` | shared visual design (light academic minimal) |
| `encrypt.py` | helper to regenerate ciphertext from plaintext |
| `sync.sh` | one-shot commit + push |
| `_private_content.html` | (gitignored) plaintext draft for Others — never commit |

## Update normal content

Edit `index.html` / `style.css`, then:

```bash
./sync.sh                    # auto commit message
./sync.sh "added paper"      # custom message
```

GitHub Pages rebuilds within ~30 seconds.

## Update the Others (password-protected) page

There are two ways:

### Option A — in the browser (no Python needed)

1. Open `https://2004lryan.github.io/others.html`
2. Enter the password to unlock
3. Open the "Edit content" panel at the bottom
4. Paste new HTML into the textarea, click **Generate ciphertext**, copy the result
5. In `others.html`, find the line `const CIPHERTEXT = "..."` near the bottom and replace the value with what you copied
6. `./sync.sh`

### Option B — via Python (more convenient for long content)

1. Edit `_private_content.html` (this file is gitignored — safe to keep plaintext)
2. Run:
   ```bash
   python3 encrypt.py _private_content.html
   # prompts for password
   ```
3. Copy the printed ciphertext into the `CIPHERTEXT` constant in `others.html`
4. `./sync.sh`

## Security notes

- Content is encrypted with AES-256-GCM, key derived via PBKDF2-SHA256 with 200,000 iterations.
- Without the password, the public ciphertext blob reveals **nothing** — view-source won't help.
- Strength depends on the password. A weak password can still be brute-forced offline.
- **Never commit `_private_content.html`** — it's gitignored as a safety net, but double-check `git status` before pushing.
