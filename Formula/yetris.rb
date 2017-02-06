class Yetris < Formula
  desc "Customizable Tetris for the terminal."
  homepage "https://github.com/alexdantas/yetris"
  url "https://github.com/alexdantas/yetris/archive/v2.3.0.tar.gz"
  sha256 "720c222325361e855e2dcfec34f8f0ae61dd418867a87f7af03c9a59d723b919"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b6a16e41ac6321347a7609cda1fbc56bd10dab8ae84182e606e09c44cf59ed9" => :el_capitan
    sha256 "07f963700d2445ff2a2b66c4aaafa236604050f515b46ac2661ffda0ce2913ec" => :yosemite
    sha256 "c77601064ff9c03eda3ca9ef8a97043b2abc130f5dbef707f7ab1001ed6c0768" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/yetris --version")
  end
end
