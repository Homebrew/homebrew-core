class Screenfetch < Formula
  desc "Generate ASCII art with terminal, shell, and OS info"
  homepage "https://github.com/KittyKatt/screenFetch"
  url "https://github.com/KittyKatt/screenFetch/archive/v3.9.0.tar.gz"
  sha256 "d6df4ef7763f9761d818c878465d78ef701b71002a50d4f150f65a31cc1bea37"
  head "https://github.com/KittyKatt/screenFetch.git", :shallow => false

  bottle :unneeded

  def install
    bin.install "screenfetch-dev" => "screenfetch"
    man1.install "screenfetch.1"
  end

  test do
    system "#{bin}/screenfetch"
  end
end
