class Tmex < Formula
  desc "Minimalist tmux layout manager"
  homepage "https://github.com/evnp/tmex"
  url "https://github.com/evnp/tmex/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "83f16a8231c1c14105134c5e30d1294b41011de2e624e2a91f37d335b5a01712"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1856efaa4a1c0681e228b50e4aaaf6c18d0b916ccfaef88d14c44a3740bb60bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1856efaa4a1c0681e228b50e4aaaf6c18d0b916ccfaef88d14c44a3740bb60bd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1856efaa4a1c0681e228b50e4aaaf6c18d0b916ccfaef88d14c44a3740bb60bd"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcd486330392d71fd11f6add42b98b213c29dea7bf6e0cb3ca0b323e078f6eea"
    sha256 cellar: :any_skip_relocation, ventura:       "fcd486330392d71fd11f6add42b98b213c29dea7bf6e0cb3ca0b323e078f6eea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcd486330392d71fd11f6add42b98b213c29dea7bf6e0cb3ca0b323e078f6eea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fcd486330392d71fd11f6add42b98b213c29dea7bf6e0cb3ca0b323e078f6eea"
  end

  depends_on "tmux"

  uses_from_macos "bash"

  def install
    bin.install "tmex"
    man1.install "man/tmex.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmex -v 2>&1")

    assert_match "new-session -s test", shell_output("#{bin}/tmex test -tp 1224")
  end
end
