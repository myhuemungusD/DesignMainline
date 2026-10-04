# Design Mainline — Site Setup

Static site deployed on Vercel. No build step.

## Pages

| URL | File | Notes |
|---|---|---|
| `/` | `index.html` | Company homepage + slideshow |
| `/originals`, `/sleeves` | `sleeves.html` | Mainline Sleeves product page + live configurator |
| `/caviot` | `caviot.html` | Caviot Studio product page (`/igrinder` 301-redirects here) |
| `/forge` | `forge/` | **The Caviot Studio app itself** (`/tool` 301-redirects here) |
| `/studio` | `studio.html` | Studio services, about, contact form |

Routes, redirects and headers live in `vercel.json`. `.vercelignore` keeps repo-only files (`uploads/`, `scraps/`, `*.zip`, `*.md`) off the live site.

## Updating Caviot Studio

The app is developed in [`myhuemungusD/caviot-studio`](https://github.com/myhuemungusD/caviot-studio). `forge/` is a copy of that repo's `dist/` folder. To ship a new build:

```bash
git clone https://github.com/myhuemungusD/caviot-studio ../caviot-studio   # or git pull
scripts/sync-caviot.sh ../caviot-studio
git add forge && git commit -m "Update Caviot Studio build" && git push
```

The script copies `dist/` into `forge/` and adds `<base href="/forge/">` so the app's relative paths resolve correctly at `/forge`.

Caviot Studio is currently **free** (launch edition). To charge later, add a checkout to the app and update the Pricing section and FAQ in `caviot.html`.

## Adding photos

- **Homepage slides:** add `assets/slides/02-caviot-studio.jpg`, `03-skatehubba.jpg`, `04-studio.jpg` (≈1600px wide), then un-comment the matching `<img>` line in `index.html`.
- **Sleeves gallery:** add `assets/sleeves/04.webp`–`06.webp` (1200×1200), then un-comment those entries in the `SHOTS` list in `sleeves.html`.

## Ordering (Mainline Sleeves)

"Order This Sleeve" opens a pre-filled email with the customer's text, colors and finish. Replace the `mailto:` in `updateOrderLink()` (`sleeves.html`) with a checkout link when one exists.
