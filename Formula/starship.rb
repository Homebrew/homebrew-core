class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.11.0.tar.gz"
  sha256 "a99a9f1116ae222e04e93c6d64fc047af5579e25be6284a58348912336116009"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any
    sha256 "34d4292dc6f07475bc0c7bf18a6efa81358128ecb336b8c588cf80b28c6c2bfd" => :mojave
    sha256 "b5994a0abe071e6b2b9c20c6729864048e68f0f5a3be5751bbdc6f8816f44fc1" => :high_sierra
    sha256 "a4c108d85774584195a8c185756a2572a9c7e8a8488f4093e32f3c933ef32224" => :sierra
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
