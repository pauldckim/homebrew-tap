cask "ltop" do
  arch arm: "arm64", intel: "x86_64"

  version "0.1.1"
  sha256 arm:   "d9bd7a20b908a5268367d8f7d463da1ca6e7a7cd308c556f420179a4c7b73976",
         intel: "f84a6e8206e851cb17b8d07bc6420fa9ead1a9daa3b30b7fdee674ef323d7f83"

  url "https://github.com/pauldckim/ltop-release/releases/download/v#{version}/ltop-v#{version}-macos-#{arch}.zip"
  name "ltop"
  desc "Single-binary TUI monitor for llama.cpp llama-server and its local process"
  homepage "https://github.com/pauldckim/ltop-release"

  livecheck do
    url "https://github.com/pauldckim/ltop-release/releases/latest"
    strategy :github_latest
  end

  # 0.1.1 ships both Apple architectures, so the 0.1.0
  # `depends_on arch: :x86_64` is removed. 11.0 (Big Sur) is the
  # arm64 macOS floor and the oldest macOS Homebrew 6 can express.
  depends_on macos: :big_sur

  # The release archive contains a single top-level directory with
  # the binary nested inside; reference it by that path.
  binary "ltop-v#{version}-macos-#{arch}/ltop"

  caveats <<~EOS
    ltop is distributed under a proprietary freeware license (see
    https://github.com/pauldckim/ltop-release/blob/main/LICENSE.md): free
    to use and to redistribute unmodified; no sale, no modification, no
    reverse engineering. The source code is not published.

    The v0.1.1 macOS binaries are ad-hoc signed: the arm64 binary must
    carry at least an ad-hoc signature to launch on Apple Silicon, and
    the x86_64 binary is ad-hoc signed for consistency. Ad-hoc signing
    is NOT a Developer ID signature — the binaries are not Developer-ID
    signed or notarized, and this cask does not remove the macOS
    quarantine attribute for you. The first run of `ltop` will be
    blocked by Gatekeeper.

    Before unblocking it, verify the checksum of the downloaded archive
    (Homebrew already verified this SHA-256 during install; to re-check
    the cached download):

      shasum -a 256 "$HOME/Library/Caches/Homebrew/downloads/"*--ltop-v0.1.1-macos-*.zip
      # expected (Apple Silicon / arm64):
      #   d9bd7a20b908a5268367d8f7d463da1ca6e7a7cd308c556f420179a4c7b73976
      # expected (Intel / x86_64):
      #   f84a6e8206e851cb17b8d07bc6420fa9ead1a9daa3b30b7fdee674ef323d7f83

    Then unblock the binary by either:

      1. removing the quarantine attribute recursively, before the
         first run:
         xattr -dr com.apple.quarantine "$(brew --prefix)/Caskroom/ltop"

      2. or running `ltop` once (it will be blocked), then opening
         System Settings > Privacy & Security and clicking "Open Anyway"
         next to the ltop warning

    If `ltop` was already run once and blocked, option 1 alone may not
    be enough (macOS caches the assessment per path); use option 2 or
    reboot in that case.

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
