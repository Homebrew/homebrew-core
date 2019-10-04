class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.20.1.tar.gz"
  sha256 "8c87921ece4b6048fa18ecf95e7887b6266473ab74a9527512dd32628d7951af"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7931785b8a1ce2b3f937ec53cccfb766c257729e07af879d9a08bb06061834aa" => :catalina
    sha256 "d71b0328b9ff2c448603f679fe6e60abb43d865fef807b155f8b81a06ca8a778" => :mojave
    sha256 "2dce8ea7236299e9eca5d53f4ac6af432c53801c76a33f0731739847230c34af" => :high_sierra
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
