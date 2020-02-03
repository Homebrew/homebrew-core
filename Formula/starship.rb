class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.34.0.tar.gz"
  sha256 "06ed28a0db72462878664d7fad57e74dae842d63460e3e949e1ada15b53f099e"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2fcf639cd449b211179f102b54e8f60293c1efaa9222a42e6a544f82e2929d61" => :catalina
    sha256 "2b59dcbc3bdb37652f8d49bb648a8970c995bd4493979e3763619dbbe67d51ca" => :mojave
    sha256 "0a650fb57fd0dbe002d11cba09d5ae254d6f3d78695ded147142a59a3d086b33" => :high_sierra
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
