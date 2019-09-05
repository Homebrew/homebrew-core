class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.14.1.tar.gz"
  sha256 "2847dcfb604ae1ba49b99310cc0d2a279e8f3f57d17806c219df9fb8c6196c49"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any
    sha256 "99f3937318d4268fbb1d86bd1cb038d3ea2b306b6b34b9802a589499623c3339" => :mojave
    sha256 "0a6d97fe2680cdc67c378d5fd7829cd639d14dbefdeb885a992bd09c256bde53" => :high_sierra
    sha256 "be95c55fc90b20806b4f534c0bffa2d08fb7693b8cfc8b8f2c726b5b4ebb8b39" => :sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
