# pauldckim/homebrew-tap

Homebrew tap for [ltop](https://github.com/pauldckim/ltop-release) — a
single-binary, keyboard-only terminal dashboard that monitors a local
[llama.cpp](https://github.com/ggml-org/llama.cpp) `llama-server` and the
OS process behind it (read-only).

## Install

```sh
brew install --cask pauldckim/tap/ltop
```

That is the whole install — one command, and here is exactly what it does:

- **Auto-tap.** The fully-qualified cask name `pauldckim/tap/ltop` makes
  Homebrew tap `pauldckim/tap` automatically (cloning this repository,
  `pauldckim/homebrew-tap`) if it is not tapped yet. No separate
  `brew tap` step is needed.
- **Scoped trust (Homebrew ≥ 6).** Non-official taps must be explicitly
  trusted before Homebrew will load their casks. A fully-qualified
  install trusts **only this cask** (`pauldckim/tap/ltop`), recorded in
  `~/.homebrew/trust.json` — it does not blanket-trust the whole tap.
  If you install by the bare name instead (`brew install --cask ltop`),
  trust it first: `brew trust --cask pauldckim/tap/ltop`.
- **Official source only.** The cask is declarative: Homebrew downloads
  the release archive from the official GitHub release
  ([`pauldckim/ltop-release`](https://github.com/pauldckim/ltop-release))
  and verifies its SHA-256. This tap repository contains no binaries and
  no install scripts — nothing is copied out of the tap and executed
  locally.

## First run (unsigned binary)

ltop is proprietary freeware (full license:
[release repo LICENSE.md](https://github.com/pauldckim/ltop-release/blob/main/LICENSE.md);
the source code is not published), and the v0.1.0 macOS binary is **not**
Developer-ID signed or notarized. This cask does **not** remove the macOS
quarantine attribute for you, so the first run of `ltop` is blocked by
Gatekeeper. `brew install` prints the exact steps as cask caveats:

1. Verify the archive checksum (Homebrew already verified the SHA-256
   during install; the caveats show how to re-check the cached download).
2. Unblock the binary by either
   - running `ltop` once (it is blocked), then opening
     **System Settings → Privacy & Security** and clicking
     **Open Anyway** next to the ltop warning, or
   - explicitly removing the quarantine attribute yourself:
     `xattr -d com.apple.quarantine /usr/local/bin/ltop`.

Developer-ID signing + notarization is the proper fix and is planned;
until then, treat this cask as a convenience channel, not an
Apple-validated install.

## Uninstall

```sh
brew uninstall --cask ltop
brew untrust --cask pauldckim/tap/ltop   # optional: drop the trust entry
brew untap pauldckim/tap                  # optional: remove the tap
```

## Supported platform

macOS x86_64 only. v0.1.0 ships a macOS x86_64 binary; the cask declares
`depends_on arch: :x86_64` and will not install on Apple Silicon.
