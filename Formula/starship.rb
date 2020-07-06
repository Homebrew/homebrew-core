class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.44.0.tar.gz"
  sha256 "b002fa0e2b34ad59330a543461a51648751db4ae8d439d58065a3b9656772fe3"
  license "ISC"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3a34f4edf92bc367f3db5da9579be06d616bcc774119a115c97641b849a805a" => :catalina
    sha256 "1d04e06d566895e65579c71eb27d9810ac6048877d06e6c088be377a67129844" => :mojave
    sha256 "2238d71f7941e44782966a1836d455b76d11eabc015f3afed70f27210d1c297c" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
