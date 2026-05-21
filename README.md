# 2004lryan.github.io

Source for my personal homepage at https://2004lryan.github.io.

Hand-crafted static HTML/CSS — no build step, no Jekyll, no framework.

## Files

- `index.html` — page content (edit text, links, news, publications here)
- `style.css`  — visual design (dark theme, teal accent)
- `assets/`    — images (drop your photo here as `assets/avatar.jpg` and update the HTML)

## Update workflow

Edit the files, then:

```bash
./sync.sh                    # auto-message with date
./sync.sh "added new paper"  # custom message
```

GitHub Pages auto-rebuilds within ~30 seconds of pushing to `main`.
