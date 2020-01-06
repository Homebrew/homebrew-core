class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.33.0.tar.gz"
  sha256 "edcd9ab6fb26506cc2745a8e74916cc77964482125e61b166a6cc61c93126231"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e9d247d78a57623898e4ad47c06b34539580435bd6526fa23d0b757bab7bcf2" => :catalina
    sha256 "535d9b655b9d09ffb3c3db23ec101336a40da5245992fcfa56fa57d12e860ecf" => :mojave
    sha256 "5ee1b33f6b1077364b6f74968b58798ae2714eaa901893d8f1982a8d7f8a13b3" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
