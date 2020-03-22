class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.38.1.tar.gz"
  sha256 "3eb01abfa038994ed24d520bfabbb30273ed90909ee87b58a854d92ad5a6db9a"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "019d3d30a011723d13e4974c688b2db85fbb6c67967887f2ed6d34726fcb1c3a" => :catalina
    sha256 "dbc43f70f31dc26a2eea029e85515d8ec15066f2d94102586aa6acbf05035e0c" => :mojave
    sha256 "be35870540bb139c2cc72ac2feccd6d30d0258ac5150440c21d8186da6cc5b81" => :high_sierra
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
