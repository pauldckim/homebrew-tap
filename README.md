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

## First run (ad-hoc signed binary)

ltop is proprietary freeware (full license:
[release repo LICENSE.md](https://github.com/pauldckim/ltop-release/blob/main/LICENSE.md);
the source code is not published). The v0.1.1 macOS binaries are
**ad-hoc signed** — the arm64 binary must carry at least an ad-hoc
signature to launch on Apple Silicon, and the x86_64 binary is ad-hoc
signed for consistency. **Ad-hoc signing is not a Developer ID
signature:** the binaries are not Developer-ID signed or notarized, and
this cask does **not** remove the macOS quarantine attribute for you, so
the first run of `ltop` is blocked by Gatekeeper. `brew install` prints
the exact steps as cask caveats:

1. Verify the archive checksum (Homebrew already verified the SHA-256
   during install; the caveats show how to re-check the cached download).
2. Unblock the binary by either
   - removing the quarantine attribute recursively, before the first
     run: `xattr -dr com.apple.quarantine "$(brew --prefix)/Caskroom/ltop"`, or
   - running `ltop` once (it is blocked), then opening
     **System Settings → Privacy & Security** and clicking
     **Open Anyway** next to the ltop warning.

   If `ltop` was already run once and blocked, the quarantine removal
   alone may not be enough (macOS caches the assessment per path); use
   the System Settings option or reboot in that case.

Developer-ID signing + notarization is the proper fix and is planned;
until then, treat this cask as a convenience channel, not an
Apple-validated install.

## Uninstall

```sh
brew uninstall --cask ltop
brew untrust --cask pauldckim/tap/ltop   # optional: drop the trust entry
brew untap pauldckim/tap                  # optional: remove the tap
```

## Supported platforms

macOS **arm64 and x86_64** (Apple Silicon and Intel). v0.1.1 ships a
binary for each architecture; the cask selects the per-architecture
archive and SHA-256 (`arch arm: "arm64", intel: "x86_64"`,
`sha256 arm: …, intel: …`) and requires macOS ≥ 11 (Big Sur) — the
arm64 macOS floor. (The 0.1.0 cask was x86_64-only via
`depends_on arch: :x86_64`.)

## Maintainer policy

- **Cask updated per published release.** The cask is changed only after
  the corresponding ltop release exists as a published GitHub Release on
  [`pauldckim/ltop-release`](https://github.com/pauldckim/ltop-release) —
  the cask commit lands after the release, so the cask URL always
  resolves — and pins the new version and per-architecture SHA-256.
- **Verified maintainer identity.** Maintainer commits to this tap use
  the maintainer's verified GitHub identity (`Paul Kim
  <pauldckim@gmail.com>`). Repo-local git config does not travel with a
  clone, so set it once in each checkout before committing:

  ```sh
  git config --local user.name "Paul Kim"
  git config --local user.email "pauldckim@gmail.com"
  ```

  The maintainer's work email is never used for commits here.
- **Forward-only history.** No force-push, no history rewrite, no tag
  re-creation: a cask fix or release bump ships as a new commit, and
  released cask versions keep their history as-is.
