class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.25.1.tar.gz"
  sha256 "eb560643045c7e273525db414f2936289cf9bebdc6db0615018db77d8e6e10d0"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e87eb431964641540c1d314613b48af6152b3b07f84f50b34dbb3443dde4ac7" => :catalina
    sha256 "f390b829988dc645fcd88f3a294e166bc21bf16106cfc52522285fe5789c0853" => :mojave
    sha256 "0325fe6c67adbf59f07820c3c56300c14d8cc60bdb36de2125173fbeebd167ad" => :high_sierra
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
