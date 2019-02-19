class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v1.7.0.tar.gz"
  sha256 "e0dc1b9e50e2f023ab6922cfd2f44e27ef307dee51047800479ec2828269702b"

  bottle do
    cellar :any_skip_relocation
    sha256 "0dd5089e4510f2cd5fde52693d866f4c3cb9c29083a28e325e4b90548242f270" => :mojave
    sha256 "897acde99af1b06e2b2a7747d71674a27bb5cba284fe6f89bb641e4d56f8d3a0" => :high_sierra
    sha256 "4fa220b969485c45efa9fd87ef32e139331bca6cf7b308faf2043b03124c57d0" => :sierra
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
