class Winetricks < Formula
  desc "Download and install various runtime libraries"
  homepage "https://github.com/Winetricks/winetricks"
  url "https://github.com/Winetricks/winetricks/archive/20181203.tar.gz"
  sha256 "7144b86b499a4db733efd1f8c360555c64a1ec60af6b1049be06ee88decfcb91"
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
