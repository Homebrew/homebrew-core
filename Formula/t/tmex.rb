class Tmex < Formula
  desc "Minimalist tmux layout manager"
  homepage "https://github.com/evnp/tmex"
  url "https://github.com/evnp/tmex/archive/refs/tags/v2.0.4.tar.gz"
  sha256 "d1907435f607993b0dc2da90166ea6d2804b73f94cffdb52a7ca40e6bee63632"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c6494934f2e31caf6457d71405d8f7fa13fcbed8489a20d1e66c2c910665ada"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c6494934f2e31caf6457d71405d8f7fa13fcbed8489a20d1e66c2c910665ada"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c6494934f2e31caf6457d71405d8f7fa13fcbed8489a20d1e66c2c910665ada"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ffdcd4b358aa710a2bf465baf932722f1e1a4e0eccff83165cb52efcece2526"
    sha256 cellar: :any_skip_relocation, ventura:       "1ffdcd4b358aa710a2bf465baf932722f1e1a4e0eccff83165cb52efcece2526"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ffdcd4b358aa710a2bf465baf932722f1e1a4e0eccff83165cb52efcece2526"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ffdcd4b358aa710a2bf465baf932722f1e1a4e0eccff83165cb52efcece2526"
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
