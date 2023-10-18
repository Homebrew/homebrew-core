class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/refs/tags/v0.38.2.tar.gz"
  sha256 "18e8ae9fa2ad995af5f6c64b3c0713143d260cdc6c1a978831313bfaf305ad5e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a7f6a02985312828166a777ef1a798c057a5a4c6be5dda1711d2cf522e79280"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56284918c1e0bcbf56e579b7211be422c375cbf9ed5e1a2580d4874ee25c5da8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c96c2447a8c05a9f86475a933ad685f045a0a3680d7ef84c676068d16866915d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3e7d27c15a7aed71d3dd9fa75639b719fcb47913cd09e664b2406c9a4c251ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "91eba6d554be7859ad01079d6017ac3fb907b6d0d9bb2294a9170eebde194ae6"
    sha256 cellar: :any_skip_relocation, ventura:        "905e43f067e3802698f0d528015e83b559ae1568afecd08910758a804e92217e"
    sha256 cellar: :any_skip_relocation, monterey:       "2bddbc92eb031b412fa4fc64ea2b2b5c5a7ca0b3b3bd8a4e19de391107dcd0f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "1863058033a21e3d977326f390d735d91079130bd869114a8aae1b1d35bb1cf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbb1dffe561563a1668ee638b8706bdfc2f119a435f89dde387d8bdb17167c51"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
