class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.13.1.tar.gz"
  sha256 "990b0e418224900824179bc6c8fca89566696be79d68b8af191da107b7414f46"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any
    sha256 "a441c5a285a227aea20ff14f5c017407841bb8b64fc30371b040c60cb7069d66" => :mojave
    sha256 "9a0987c1546bb719b84666879bfcad351b00ad6797958e369ca407f0adde65e3" => :high_sierra
    sha256 "4d49733275f26e3db85cd66cbe76d3653514bb255ecfcaa82504839bf9085084" => :sierra
  end

  depends_on "rust" => :build
  depends_on "openssl"

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
