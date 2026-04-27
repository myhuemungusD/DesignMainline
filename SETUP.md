# Mainline Forge — Setup Guide

A paywalled 2D-image-to-3D-STL tool for designmainline.com. **$9 Stripe Buy Button → unlock download.** No backend required.

## Files

| File | Purpose |
|---|---|
| `tool.html` | The Forge UI. Drop into your repo root. Served at `/tool.html`, `/tool`, or `/forge`. |
| `vercel.json` | URL rewrites for `/forge` and `/tool` |

## 1. Deploy

Drop `tool.html` and `vercel.json` next to your existing `index.html` and push. Vercel rebuilds, page is live at `/forge`.

## 2. Configure your Stripe Buy Button redirect

Your live buy button (id `buy_btn_1TQnYKD7tGQxpyHP9PcVeEmE`) is already embedded in `tool.html`.

In your Stripe Dashboard → **Buy Buttons** → edit this button → **After payment**, set the success URL to:

```
https://designmainline.com/forge?paid=1
```

That `?paid=1` is what the page watches for to auto-unlock the download. Without that redirect setup, customers will pay but won't auto-unlock — they'll have to click the **"I already paid — unlock"** button (which is also there as a safety net).

## 3. Link from the main site

Add a fourth service card or nav link in `index.html`:

```html
<a href="/forge" class="btn-primary">Mainline Forge — $9</a>
```

## How the unlock works

1. User clicks the Stripe Buy Button → goes to Stripe-hosted checkout.
2. After payment, Stripe redirects back to `/forge?paid=1`.
3. Page sees `?paid=1`, sets `localStorage[mainline_forge_unlock_v1]`, swaps to the unlocked UI.
4. Future visits in the same browser stay unlocked (until they clear site data).

If the redirect ever fails, the **"I already paid — unlock"** button under the buy button is a manual fallback. It asks for confirmation before unlocking.

## Pricing

Change the price in your Stripe Dashboard → Products. The buy button always reflects whatever Stripe says.

## Anti-piracy notes

This is honor-system gating — anyone with dev tools can run `localStorage.setItem('mainline_forge_unlock_v1','x')` to bypass. For a $9 maker tool that's the right tradeoff; the audience is honest hobbyists. If you ever want true server-side verification, drop me a note and I'll wire up a Vercel function that calls Stripe's API to confirm payment.

## License copy

Footer says: *"Single-purchase license · Files yours to print, sell, or modify."* Edit in `tool.html` to taste.
