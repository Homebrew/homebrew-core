class Winetricks < Formula
  desc "Download and install various runtime libraries"
  homepage "https://github.com/Winetricks/winetricks"
  url "https://github.com/Winetricks/winetricks/archive/20190310.tar.gz"
  sha256 "dc86847c1c9bffd7622bd9095178b913210177f1a9c8f302e9d4e72ba39f9ff6"
  head "https://github.com/Winetricks/winetricks.git"

  bottle :unneeded

  depends_on "cabextract"
  depends_on "p7zip"
  depends_on "unrar"

  def install
    bin.install "src/winetricks"
    man1.install "src/winetricks.1"
  end

  def caveats; <<~EOS
    winetricks is a set of utilities for wine, which is installed separately:
      brew install wine
  EOS
  end

  test do
    system "#{bin}/winetricks", "--version"
  end
end
