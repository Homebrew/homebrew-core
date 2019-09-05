class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.14.1.tar.gz"
  sha256 "2847dcfb604ae1ba49b99310cc0d2a279e8f3f57d17806c219df9fb8c6196c49"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any
    sha256 "64189794918b70f8cc6e0bb470bebffc0cea392119cefe56c886fb8e531821de" => :mojave
    sha256 "5c7740f235568ecfc523addd989957cf62885aa6d460b2a44d71b87804ac4999" => :high_sierra
    sha256 "a98e4d2697dbabddc12b18f514215d33e1518cf3d470ef1f2b247009919cc4d3" => :sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
