class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v0.19.0.tar.gz"
  sha256 "0b2ebb65f3fe4884186d2a47811b7036937a0e197de34786fc99c77ce4563f0f"

  bottle do
    sha256 "b5fb00a707e58950b825d8cafd23764b6dd673affbc248aa58d8bea0bd141afb" => :mojave
    sha256 "2a8b12f079420b78240ef935a2b51e78f6c925520e1cdee2d2c7516b3df383f8" => :high_sierra
    sha256 "e8ac26ffd69015f981be1af73f3d6f86eee700bc71beea18e0e674a8051b21ea" => :sierra
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
