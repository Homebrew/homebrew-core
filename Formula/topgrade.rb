class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v0.13.0.tar.gz"
  sha256 "c1a7fe9675a4572f77afad21849ce5e512c194e4e00de17ce5590f5588ad38b9"

  bottle do
    sha256 "505ca928e99e82a7348447c6d9b5dde05a2d7b38d1f6513be5d7f0294a7a39ec" => :high_sierra
    sha256 "35293faa14fb545edade34e576e9440dcfd585174dd93fd230f02b77b4f68028" => :sierra
    sha256 "15777fae3e45142facd9421a59febe4a846d89c8ef6d252d645e67c5782fda67" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
  end

  test do
    output = shell_output("#{bin}/topgrade -n")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
  end
end
