class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.35.1.tar.gz"
  sha256 "98bbbc9b6091bd6fc5b1e65bdf2d3a860b88839fd932743b09ac8b6446378df9"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "af3f54f9f57a996d1eefca1396377a328fa47f354dcbe768a6f8be7eea33c989" => :catalina
    sha256 "155e419e4eea3155babe99933bc64c5a1201b5c1f10cb78404a35fdadc49e131" => :mojave
    sha256 "ea391f954088d404a274e4fb3a58f88b29e6635af105fab1cd163adae68677aa" => :high_sierra
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
