class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.43.0.tar.gz"
  sha256 "c50930cba2f35963d8d6ac96c54e0a6e272c0dbee5b8ce6f01c9e0ac99de8b03"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b20531ed2fde6ddcad26f24f1e3ce63582633a0da0cbfb296df04b9325080d26" => :catalina
    sha256 "ef100b0cba6d10b4506861d588ecd239aff541e838536ec1e63763c168049a4f" => :mojave
    sha256 "e0ac6fdea4f4b79ad65ab6d54ab22204e6a4dbe37077825b308f763759abd225" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
