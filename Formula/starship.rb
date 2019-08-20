class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.12.0.tar.gz"
  sha256 "d4315059a4f2d1e4997fbed8f46f1b716c58e53c6bb9f7f3eb2c4004a24b198a"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any
    sha256 "636b241f66c16be6d227170671a1ef4608db01dcd057fe131e46e56ed6553372" => :mojave
    sha256 "67a040f872147094ad8a78d6744e0ed4ec4f49f352772cc50e409e2e410df7af" => :high_sierra
    sha256 "19e1551f6833a2d79a082568bebec097fa875b606b516636703dd62fa8cd3122" => :sierra
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
