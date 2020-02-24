class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.36.1.tar.gz"
  sha256 "cfef5f1775c0ac9faf082f58377a4ead32e07c3da5b2af5b59ce14d2df103933"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f2893d0d8f0444f181efdc746411cfaec2ffdc104a2232dba6e04d4463aeef72" => :catalina
    sha256 "54d55c479d348666c1d354a6e8815b1f5c9042a064bf162d27c23f06ef509dcb" => :mojave
    sha256 "6208d4620187201d9f0706350fe14d36811adef12e1cfc16b7d4b950842ed428" => :high_sierra
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
