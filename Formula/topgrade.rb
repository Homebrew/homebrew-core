class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v2.7.0.tar.gz"
  sha256 "4e089c9e1e92c4ea6246f6771f59fcc388b23d045a150b67c1085409a432bc7c"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec24ab7525a221aaad730be687ed3b86003d612224968fcb764617e3090f4b9e" => :mojave
    sha256 "3248db7b26941602564c284cdfcd7733235de46f4dca85a67e60b9e45f768799" => :high_sierra
    sha256 "c0a8eb422cbfc8617ff091476ffa5db27b0b0ed6237f601cf75960cb1b26b3cc" => :sierra
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
