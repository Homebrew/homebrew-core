class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.26.4.tar.gz"
  sha256 "80b44efd22a8a7305c8cb31acf9b703d589f97fce009cc6be20105ff3a3d3d0c"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "56673443d52a21fe0daedf0e4b8d46c1ea1614c5f485deb91b3bacde5dc8438c" => :catalina
    sha256 "cceafd0c1f022513307dae1f3215e3ab23df8d642ccb62d93a18f6e50bdf39c8" => :mojave
    sha256 "0a06146fe49b66f0e49211b0db863c82615d9051101be72477b11ba6b05583b1" => :high_sierra
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
