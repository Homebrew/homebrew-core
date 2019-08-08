class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://github.com/starship/starship"
  url "https://github.com/starship/starship/archive/v0.5.0.tar.gz"
  sha256 "f4b611d757b6cf54ee9250a0d672453e090d0453a6e6edf96ccd740e7b607692"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any
    sha256 "557675e290b00b9934d13f4d19e459a94d10415aaf168f95ffcd1339aeda4f4b" => :mojave
    sha256 "211ef5aedd6d838a925061280733b394531844eadf7abcfba9bb11344e2d384c" => :high_sierra
    sha256 "e58e521759593586bdd3266b5f95506124f7b410bdd45c4dd4feba1098f7cb22" => :sierra
  end

  depends_on "rust" => :build
  depends_on "openssl"

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m➜[0m ", shell_output("#{bin}/starship module char")
  end
end
