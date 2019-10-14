class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.24.0.tar.gz"
  sha256 "f8cd71d7cf9b9a1ff57acd81f22960994bdaea58cfae813bd8e42146de431c0b"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "022d4b414f877dffa4a1ae2aa7fa74a24dc1361a5e7f2b4a115465a2cc01e553" => :catalina
    sha256 "376c8931945c46064e34cc2be33a74b695dbbc6e2140f4b093aa10aacf73727d" => :mojave
    sha256 "e5533a01645430ce13f5b45e0cb37fef9d4fbb9f7de564cea7c671efe16242ed" => :high_sierra
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
