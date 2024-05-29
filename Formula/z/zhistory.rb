class Zhistory < Formula
  desc "Command-line analysis tool for zsh history"
  homepage "https://github.com/itsKarad/ZHistory"
  url "https://github.com/itsKarad/ZHistory/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "1093b009dd9ca9beca551c1dc33e0924f1498247066262a7f5c8d6c7d022e8c9"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/zhistory", "--version"
  end
end
