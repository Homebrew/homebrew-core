class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v1.12.0.tar.gz"
  sha256 "5daa2e7d2642273d45b4ea24e5cc2c70664bae7d6ce59024de5f51413382add4"

  bottle do
    cellar :any_skip_relocation
    sha256 "00d792bd8737bf020cd77f214bb0e9adcb88782877da42d3061cfdaa53d37e6a" => :mojave
    sha256 "0de075e98ed404eeff95d772870230d0051ba4255bbb8d1686be03b9d0d2797b" => :high_sierra
    sha256 "cd94f77a03887a43e7e1191f540a1fe484037bbc1b6356552035377f93e5fe3b" => :sierra
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
