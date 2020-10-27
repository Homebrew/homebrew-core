class Screenfetch < Formula
  desc "Generate ASCII art with terminal, shell, and OS info"
  homepage "https://github.com/KittyKatt/screenFetch"
  url "https://github.com/KittyKatt/screenFetch/archive/v3.9.1.tar.gz"
  sha256 "aa97dcd2a8576ae18de6c16c19744aae1573a3da7541af4b98a91930a30a3178"
  license "GPL-3.0"
  head "https://github.com/KittyKatt/screenFetch.git", shallow: false

  bottle :unneeded

  def install
    bin.install "screenfetch-dev" => "screenfetch"
    man1.install "screenfetch.1"
  end

  test do
    system "#{bin}/screenfetch"
  end
end
