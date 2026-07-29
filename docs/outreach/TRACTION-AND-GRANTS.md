# Traction & grant strategy — hyperframes-selfhost

**Goal:** stars, forks, deployers, upstream co-marketing, and optional non-dilutive funding.  
**Project:** [ismailkattakath/hyperframes-selfhost](https://github.com/ismailkattakath/hyperframes-selfhost)  
**Positioning:** privacy-preserving **self-hosted video MCP** (Kinocut + HyperFrames) behind Funnel + OAuth — not HeyGen cloud.

## Reality check (baseline)

| Metric | Now | 30-day target | 90-day target |
| --- | --- | --- | --- |
| GitHub stars | 0 | 50 | 200 |
| Independent deployers (self-report) | 1 (author) | 5 | 20 |
| Mentions by upstream (Kinocut / HyperFrames / mcp-auth-proxy) | 0 | 1 | 2 |
| Grant apps submitted | 0 | 1–2 | 2–3 |

Early project = **distribution first**, large infrastructure grants second. STF/NLnet prefer proven base tech with prevalence; this packaging wins on **privacy + agent MCP + security posture**, then scale.

---

## Phase 0 — already executed / execute immediately

| Action | Status | Why |
| --- | --- | --- |
| README hero video (dogfooded) | Done | Proof the stack works |
| GitHub topics (`mcp`, `hyperframes`, `self-hosted`, …) | Done | Discoverability |
| LinkedIn launch post | This run | Professional network + agent builders |
| OpenSSF Scorecard / CI / Dependabot | Done | Grant + trust signals |
| Enable GitHub Sponsors | Pending (manual verify) | Monetization path for later |

---

## Phase 1 — distribution (week 1–2) — highest ROI

### 1. Social / communities (ordered)

1. **LinkedIn** (primary): launch post + reply to every comment in 24h; repost on day 3 with a setup tip.
2. **X / Twitter** (if account): 1–2 short threads linking README WebP + “Funnel + OAuth + local MP4”.
3. **Hacker News** — *Show HN: Self-host a video MCP (Kinocut + HyperFrames) behind Tailscale Funnel + Google OAuth*  
   - Best window: US morning weekday.  
   - Title ≤ 80 chars; first comment = architecture + threat model.
4. **Reddit** (value-first, not spam):  
   - r/selfhosted, r/LocalLLaMA, r/mcp (if exists), r/Tailscale — one post each, different angle (privacy / agents / Funnel).
5. **Discord / Slack:** HyperFrames Discord, Tailscale community, Anthropic/Claude communities if allowed, Kinocut channels.

### 2. Upstream co-marketing (high leverage)

| Project | Ask | Template |
| --- | --- | --- |
| [KyaniteLabs/kinocut](https://github.com/KyaniteLabs/kinocut) | “Self-host reference deploy” link in README/docs | Issue or polite maintainer DM |
| [heygen-com/hyperframes](https://github.com/heygen-com/hyperframes) | Community “self-host MCP” pointer (not competing with hosted MCP) | Discussion / issue |
| [sigbit/mcp-auth-proxy](https://github.com/sigbit/mcp-auth-proxy) | Example deployment | PR to their examples if they accept |
| Tailscale | Funnel example / showcase | community@ or showcase form |

### 3. Content flywheel (1 asset / week)

| Week | Asset |
| --- | --- |
| 1 | LinkedIn + Show HN + this strategy |
| 2 | Short “threat model” post (Funnel vs open ports vs Cloudflare Tunnel) |
| 3 | 60s screen capture: `install.sh` → first MCP tool call |
| 4 | Compare: HeyGen hosted MCP vs this stack (honest table) |

---

## Phase 2 — product traction (week 2–6)

1. **v0.2 packaging polish** that unblocks second deployers: multi-arch notes, ARM64 Chromium already learned, `doctor.sh` excellence.
2. **Issue labels:** `good first issue`, `help wanted`, `docs`.
3. **Discussions** enabled on GitHub for Q&A.
4. **Awesome lists:** PR to awesome-mcp, awesome-selfhosted, awesome-tailscale if criteria met.
5. **Cachix/GHCR image** (optional): prebuilt MCP image cuts install friction.

---

## Phase 3 — funding grants (after some traction OR parallel soft apps)

### Fit matrix (2026 landscape)

| Program | Fit | Window | Notes |
| --- | --- | --- | --- |
| **NGI Taler / Fediversity** (NLnet pilots still open) | Low–med | ~Aug 1 2026 | Only remaining NGI pilots while main NGI0 paused |
| **NLnet regular calls** | Medium | After summer 2026 reopen (“Open Internet Stack”) | Watch [nlnet.nl/funding](https://nlnet.nl/funding.html) |
| **Sovereign Tech Fund** | Medium (later) | Rolling | Prefers **prevalence** + base tech; re-apply once stars/deployers exist; portal [apply.sovereigntechfund.de](https://apply.sovereigntechfund.de/) |
| **GitHub Sponsors** | High (infra) | Anytime | Enable now; fund maintenance not “raise” |
| **GitHub Secure Open Source / Accelerator** | Low now | Cohort-based | Need security narrative + usage |
| **Microsoft FOSS Fund** | Opportunistic | Employee-voted | Can’t apply directly; grow awareness inside MS |
| **Prototype Fund / country programs** | Depends on residency | Varies | Check DE/NL/etc. if eligible |

**Honest take:** at **0 stars / day-0 public**, large STF-style grants are a long shot. Use Phase 1–2 to create the evidence package, then submit.

### Grant narrative (reusable)

> **Problem:** Cloud agents need a public MCP endpoint for video tools; hosted endpoints export media and burn credits; naive self-host opens ports or skips OAuth.  
> **Solution:** Opinionated compose stack — Funnel edge, Caddy, mcp-auth-proxy (OAuth 2.1 + allowlist), Kinocut + HyperFrames local render.  
> **Commons angle:** Reusable pattern for *any* sensitive MCP (not only video): public URL, private host, real identity gate.  
> **Ask:** €15–40k equivalent for (1) multi-arch hardened images, (2) formal threat model + independent review, (3) docs + installer UX, (4) optional NixOS module upstreaming.

One-pager: `docs/outreach/grant-one-pager.md`.

---

## Phase 4 — partnerships & credibility

1. Blog on kattakath.com / ismail.kattakath.com  
2. Conference lightning talks (MCP / self-host / agent infra)  
3. Cross-post to Dev.to / Hashnode for SEO  
4. Track referrals with UTM on key links (`?utm_source=linkedin` etc.)

---

## Execution checklist (this session + next 7 days)

- [x] Topics on GitHub  
- [x] LinkedIn publish (Kapture) — https://www.linkedin.com/feed/update/urn:li:share:7488043875425611777/  
- [ ] Enable GitHub Sponsors (profile)  
- [x] Open GitHub Discussions  
- [ ] Draft Show HN title + first comment  
- [x] File friendly upstream issues (Kinocut #432, HyperFrames #2866, mcp-auth-proxy #182)  
- [ ] Schedule day-3 LinkedIn tip post  
- [ ] Watch NLnet reopen; book STF draft after 50★ or 5 deployers  

---

## Anti-patterns

- Spam identical posts across every subreddit same day  
- Claiming affiliation with HeyGen  
- Applying to STF with zero external users yet (unless framed as *new* commons with exceptional security novelty)  
- Auto-DM lists without relationship  
