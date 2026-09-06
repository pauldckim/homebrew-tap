cask "ltop" do
  version "0.1.0"
  sha256 "e4d60310db4f638f9cf01e182be1bc35e1b39678e0dcf9d7c260e2a84b7a5b42"

  url "https://github.com/pauldckim/ltop-release/releases/download/v#{version}/ltop-v#{version}-macos-x86_64.zip"
  name "ltop"
  desc "Single-binary TUI monitor for llama.cpp llama-server and its local process"
  homepage "https://github.com/pauldckim/ltop-release"

  livecheck do
    url "https://github.com/pauldckim/ltop-release/releases/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
  end

  depends_on arch: :x86_64
  # Oldest macOS Homebrew 6 can express; the binary's Mach-O minimum is
  # 10.12 (LC_VERSION_MIN_MACOSX), so 11 is a safe lower bound.
  depends_on macos: :big_sur

  # The release archive contains a single top-level directory with the
  # binary nested inside; reference it by that path.
  binary "ltop-v#{version}-macos-x86_64/ltop"

  caveats <<~EOS
    ltop is distributed under a proprietary freeware license (see
    https://github.com/pauldckim/ltop-release/blob/main/LICENSE.md): free
    to use and to redistribute unmodified; no sale, no modification, no
    reverse engineering. The source code is not published.

    The v0.1.0 macOS binary is NOT Developer-ID signed or notarized, and
    this cask does not remove the macOS quarantine attribute for you.
    The first run of `ltop` will be blocked by Gatekeeper.

    Before unblocking it, verify the checksum of the downloaded archive
    (Homebrew already verified this SHA-256 during install; to re-check
    the cached download):

      shasum -a 256 "$HOME/Library/Caches/Homebrew/downloads/e4d60310db4f638f9cf01e182be1bc35e1b39678e0dcf9d7c260e2a84b7a5b42--ltop-v0.1.0-macos-x86_64.zip"
      # expected: e4d60310db4f638f9cf01e182be1bc35e1b39678e0dcf9d7c260e2a84b7a5b42

    Then unblock the binary by either:

      1. running `ltop` once (it will be blocked), then opening
         System Settings > Privacy & Security and clicking "Open Anyway"
         next to the ltop warning; or

      2. explicitly removing the quarantine attribute yourself:
         xattr -d com.apple.quarantine /usr/local/bin/ltop

    Developer-ID signing + notarization is the proper fix and is
    planned; until then, treat this cask as a convenience channel, not
    an Apple-validated install.
  EOS

  # No `uninstall` stanza: the `binary` stanza creates a symlink in
  # Homebrew's bin directory, and Homebrew removes that symlink
  # automatically on `brew uninstall --cask ltop`. ltop installs nothing
  # else (no app bundle, no support files), so there is nothing left to
  # trash.
end
