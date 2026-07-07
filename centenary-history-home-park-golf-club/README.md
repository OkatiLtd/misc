# The Centenary History of the Home Park Golf Club — flipbook

A self-contained, page-through web edition of *The Centenary History of the
Home Park Golf Club* by J. G. C. Pope (1895–1995), built as a static
[StPageFlip](https://github.com/Nodlik/StPageFlip) viewer. No server, no runtime
build, no CDN — just HTML, a vendored copy of the library, and the page images.

Designed to live inside a general-purpose **`misc`** repository, so the public
URL carries the book's title:

```
https://<your-username>.github.io/misc/centenary-history-home-park-golf-club/
```

## Contents

```
index.html            The viewer (controls, keyboard/slider nav, zoom, fullscreen, About/disclaimer)
lib/page-flip.browser.js   StPageFlip 2.0.7, vendored
pages/page-001.jpg … page-092.jpg   One image per book leaf, in reading order
build/build.sh        Regenerate pages/ from the two source PDFs
README.md             This file
```

(The repo root also holds an empty `.nojekyll` so GitHub Pages serves everything
as-is.)

## 1 · Set up GoatCounter (visit tracking)

1. Go to https://www.goatcounter.com/ and create a free site. Pick a code —
   e.g. `okati-book` — which becomes `https://okati-book.goatcounter.com`.
2. In `index.html`, find the GoatCounter block in `<head>` and replace
   `YOURCODE` with your code:

   ```html
   <script data-goatcounter="https://okati-book.goatcounter.com/count"
           async src="//gc.zgo.at/count.js"></script>
   ```

That's it — each visit is counted, and your dashboard is at
`https://okati-book.goatcounter.com`. (The viewer is a single page, so this
records one visit per open, which is what you want here.)

## 2 · Publish on GitHub Pages (repo named `misc`)

The whole thing is pre-built, so there's no build step and no GitHub Actions —
Pages just serves the files (keeping it off your Actions minutes).

**With the GitHub CLI:**
```bash
cd misc                       # the folder that contains .nojekyll and this book folder
gh repo create misc --public --source=. --remote=origin --push
```
Then in the repo: **Settings → Pages → Build and deployment → Deploy from a
branch → `main` / `/ (root)` → Save.**

**With plain git (create an empty `misc` repo on github.com first):**
```bash
cd misc
git init && git add . && git commit -m "Add Home Park Golf Club flipbook"
git branch -M main
git remote add origin https://github.com/<your-username>/misc.git
git push -u origin main
```
Then set **Settings → Pages** as above.

After a minute the book is live at
`https://<your-username>.github.io/misc/centenary-history-home-park-golf-club/`.

### Worth knowing
- **Public repo = public book.** Anyone with the URL can read it; Pages has no
  access control. A private repo needs a paid plan and the site is still
  URL-reachable.
- **Size / bandwidth.** `pages/` is ~35 MB — well under the ~1 GB site and
  100 GB/month bandwidth soft limits.
- **The source PDFs are not included**, so they aren't downloadable unless you
  add them.

## 3 · iPads and phones

Yes. The viewer is responsive and touch-enabled:
- **Phones and iPad held upright** → one page at a time (easier to read).
- **iPad landscape / laptops / desktops** → the two facing pages as a book.
Turn pages by swiping, dragging a corner, tapping Prev/Next, or the arrow keys.

## 4 · The okati.co.uk link and disclaimer

A discreet **okati.co.uk** link sits in the sub-footer, and the **About &
disclaimer** panel (same row) states that the edition is provided as a
convenience and is not a product of, or endorsed by, Okati Ltd or anyone
associated with it, acknowledges third-party copyright, offers a takedown
contact, and repeats the okati link. Edit the wording in `index.html` (search
for `about-card`) if you want to add a contact address.

## Rebuilding the images

Put the two PDFs in `build/` (or pass their paths) and run, from this folder:

```bash
./build/build.sh path/to/part1.pdf path/to/part2.pdf
```
Requires `poppler-utils` (`pdftoppm`) and Python + Pillow. Tunables:
`DPI` (150), `TARGET_H` (1700), `QUALITY` (82), `SPREAD_ASPECT` (1.3). If the
leaf count changes, update `TOTAL` near the top of the script block in
`index.html`.

## Credits
Text and images © their respective rights holders; *The Centenary History of the
Home Park Golf Club* by J. G. C. Pope. Viewer built with StPageFlip (MIT).
