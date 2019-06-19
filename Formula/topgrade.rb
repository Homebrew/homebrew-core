class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v2.3.1.tar.gz"
  sha256 "e16404d0156f0b9f3ff254053633320b0f1c4c8f1a2cecb92da674ff2a55297a"

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
