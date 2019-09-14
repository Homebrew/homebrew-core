class Winetricks < Formula
  desc "Download and install various runtime libraries"
  homepage "https://github.com/Winetricks/winetricks"
  url "https://github.com/Winetricks/winetricks/archive/20190912.tar.gz"
  sha256 "acedd8aebe9a7fef4548ff8a47cc8ab7e6d13f6051c1b79d51cd4105e0f7fb9f"
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
