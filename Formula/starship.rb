class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.23.0.tar.gz"
  sha256 "32dcdd879c044badc5ed0ba6d1ec6667b6e44abb6d9e1032746c1aed3b26ce8f"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8ac56655cbeecc2607f52481f66facffd69719fa9b7b5ace60bc9c8d37b6c4d" => :catalina
    sha256 "7daaec61364e3bff198bd789cafe95daaa664581bc8d32a026d0371da8eafd06" => :mojave
    sha256 "000d66ab0abc60c5c9965bf6145216451cfd662ea780deeb86625eb6414bb7ad" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
