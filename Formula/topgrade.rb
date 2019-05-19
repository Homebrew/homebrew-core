class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v1.13.0.tar.gz"
  sha256 "c94a9c53191b301a80e5e817b24a141bb5cdebddcb0ed37b72d0edf3049a3276"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3db9087fe5d9f38b3b0fa41a8f1a577fe50efd4d8f241099c8f5bf41e24de34" => :mojave
    sha256 "e044ba230ee61e8074732012c543e5c4c45aa76d3131138763f1b027fc3cd3c4" => :high_sierra
    sha256 "1e89f61f920cd5b499c99db079e739774e6dc5d0e4930cf3dc5b47bdc0b7e65d" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/topgrade -n")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
