class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v1.12.0.tar.gz"
  sha256 "5daa2e7d2642273d45b4ea24e5cc2c70664bae7d6ce59024de5f51413382add4"

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
