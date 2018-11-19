class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v1.0.1.tar.gz"
  sha256 "e3551da7763e7219217a695a3445855d634e1428737c8a01a6e5832d31a7fc8d"

  bottle do
    sha256 "6b79904140ce3029370f467ee371975d5a04a7d365f5fa85d9375cb0befa58fa" => :mojave
    sha256 "4f61130c8e00ed3d99c03f0bfcc957a28ef6937308c43296aeef195669cc2015" => :high_sierra
    sha256 "c2ad6f3ed305dfd86248fae7c1c2155d4d4c45489ab6ac3db3a75f65ae5b0434" => :sierra
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
