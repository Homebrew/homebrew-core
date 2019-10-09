class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.22.0.tar.gz"
  sha256 "ed60db278a8d7cf45a21814ea80afe8b83fa5f6cd79a10844c7296d9670a48a6"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fbc88c44889ecb2beaa0298b2e1b12c0103d8cdb3517e4c7aaa3d67acc997a7" => :catalina
    sha256 "c90a8ffd25a82d80a5e55d50d1a579d5efda83e4a2cd30fc2ee35808ded7a03c" => :mojave
    sha256 "39170ca815e8895a6a0a2eb754485fe918271dc5263fdd4425aa2ddc69c3c8b0" => :high_sierra
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
