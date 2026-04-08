# Calvin Score Scanner Dashboard

Live at: https://clawyourface.github.io/scanner-dashboard/

## What This Is

A web dashboard that displays Calvin Score scanner results. Reads from CSV files in the `scans/` folder and renders an interactive view with composite scores, factor breakdowns, radar charts, Lynch Tunnel indicators, and deployment allocations.

## How It Works

1. Claude runs the scanner in Cowork (triggered by "run the scanner" or similar)
2. Claude pulls live data from stockanalysis.com and secondary sources
3. Claude scores each ticker using the Calvin Score formulas
4. Claude writes results to a timestamped CSV in `scans/` (e.g., `scan-2026-04-07-1500.csv`)
5. Calvin double-clicks `push.bat` to deploy
6. Dashboard at GitHub Pages auto-updates within ~2 minutes

## File Structure

```
scanner-dashboard/
  index.html          — The dashboard (self-contained HTML + React via CDN)
  push.bat            — One-click deploy script
  README.md           — This file
  scans/              — All scan CSV files (timestamped, never overwritten)
    scan-YYYY-MM-DD-HHMM.csv
```

## CSV Schema

Each scan file contains one row per ticker with these columns:

**Metadata (same for all rows in a scan):**
- `scan_timestamp` — ISO 8601 timestamp of when the scan was run
- `scan_mode` — full, single, or discovery
- `deploy_cash` — cash amount available for deployment (0 if none specified)

**Ticker data:**
- `ticker`, `name` — stock identifier and company name
- `price`, `high_52w` — current price and 52-week high
- `trailing_pe`, `forward_pe`, `trailing_peg` — valuation ratios from stockanalysis.com
- `forward_eps_growth`, `forward_peg` — calculated by Claude
- `gross_margin`, `operating_margin`, `roe` — quality metrics
- `fcf`, `market_cap`, `fcf_yield` — free cash flow data
- `drawdown_pct` — percentage off 52-week high
- `ma200`, `pct_below_ma200` — 200-day moving average data
- `rsi14` — RSI(14) from secondary source
- `revision_direction` — earnings revision sentiment (strong_up, moderate_up, flat, moderate_down, strong_down)
- `hist_avg_pe`, `median_hist_pe` — historical P/E benchmarks from protocol
- `trailing_eps`, `forward_eps` — earnings per share

**Scores:**
- `growth_score`, `value_score`, `quality_score`, `discount_score` — four factor scores (0-100)
- `calvin_score` — composite score (0-100)

**Signals:**
- `peg_signal` — dual-PEG category (strong value, accelerating, decelerating, expensive)
- `lynch_floor`, `lynch_ceiling`, `tunnel_position`, `lynch_zone` — Lynch Tunnel data
- `recommendation` — plain-language summary

## Future-Proofing

New columns can be added to future scan CSVs without breaking older files. The dashboard reads whatever columns exist and ignores missing ones. Old scan files remain readable.

## Deploying

The `push.bat` script handles git add, commit, and push using the deploy key at `../keys/scanner-deploy-key`. Just double-click it after Claude writes new scan files.

## Dashboard Features

- **Scan selector dropdown** — browse all historical scans, sorted newest first
- **Latest button** — jump to the most recent scan
- **Summary metrics** — top pick, cash to deploy, qualifying candidates, best signal
- **Composite score bars** — visual ranking of all tickers
- **Stock cards** — click to expand with radar chart, valuation metrics, and recommendation
- **Lynch Tunnel** — visual indicator of where price sits in historical P/E band
- **Deployment allocation** — score-weighted cash distribution across qualifying tickers (score >= 60)
