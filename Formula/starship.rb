class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://github.com/starship/starship"
  url "https://github.com/starship/starship/archive/v0.2.0.tar.gz"
  sha256 "27df9d27e7e5687bd16b8d7b3805b4687f667d76300e4b90e1770f925c27bade"
  head "https://github.com/starship/starship.git"

  depends_on "rust" => :build
  depends_on "openssl"

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m➜[0m ", shell_output("#{bin}/starship module char")
  end
end
