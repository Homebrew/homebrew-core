class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.11.0.tar.gz"
  sha256 "a99a9f1116ae222e04e93c6d64fc047af5579e25be6284a58348912336116009"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any
    sha256 "3ddf9eb9dd2ad0a1c1324fceffe68ccbe67662990543f142ceef95032e60bf06" => :mojave
    sha256 "43521af7cb1e226843993485a3873ab5e55a7f9ebc58f818f1f1666ac3386198" => :high_sierra
    sha256 "29694532b055d781b4873ce1940a15c5631e6237550e451bc8fc21cb97bf760d" => :sierra
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
