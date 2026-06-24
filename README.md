# 2004lryan.github.io

Source for https://2004lryan.github.io —— personal homepage of 李盼林 (Panlin Li).

Hand-crafted static HTML/CSS, no build step. Bilingual EN/中 toggle.

## Files

| File | Purpose |
|------|---------|
| `index.html` | main page (About / Research / News / Publications / Projects / Awards / IP / Education / CV / Contact) |
| `style.css`  | shared visual design (light academic minimal) |
| `assets/`    | photo, resume PDF, other static assets |
| `sync.sh`    | one-shot commit + push |

## Update content

Edit `index.html` / `style.css`, then:

```bash
./sync.sh                    # auto commit message
./sync.sh "added new paper"  # custom message
```

GitHub Pages rebuilds within ~30 seconds.

## Local preview

```bash
python3 -m http.server 8000
# open http://localhost:8000
```

Hard-refresh the browser (Cmd+Shift+R / Ctrl+F5) if styles look stale.
