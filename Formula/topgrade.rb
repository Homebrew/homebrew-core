class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v2.4.0.tar.gz"
  sha256 "b60516c1cab836ab88764a2073f3563180f6ae2af5c22b3b941df07e895209b5"

  bottle do
    cellar :any_skip_relocation
    sha256 "4393b280cf995f9b3af785744fd61e2f1b611edba626ea480c6ec50eb6103ece" => :mojave
    sha256 "d7970d56a7b95610c54d341ceb3b6fdffeb7f4b55b6d5010e44aed104ae54917" => :high_sierra
    sha256 "01ccbf1997d380113700610146680ef775cf02dfb4332fa2dd05b61ceb07f9c6" => :sierra
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
