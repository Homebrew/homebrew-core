class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.32.2.tar.gz"
  sha256 "ca8cbb2a34f38bf80839d3e9e26efc3c5009bc43aca040a03d0006a7c6f0845e"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1a720c62ddc724ec1907541c883e19001f00ef3df3ee90636698f2e333573a6" => :catalina
    sha256 "f4fd53fc452556ffc9fb31dc159948e3777912396c7d34a1797896b705351a3a" => :mojave
    sha256 "8e0807cb1feb61d73c6519d44b95c4839d03d316d246b721a76d674130f97d76" => :high_sierra
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
