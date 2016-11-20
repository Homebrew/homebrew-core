class Winetricks < Formula
  desc "Download and install various runtime libraries"
  homepage "https://github.com/Winetricks/winetricks"
  url "https://github.com/Winetricks/winetricks/archive/20161107.tar.gz"
  sha256 "4724002393e4b3ff4a01ee5210337fe285a0b4bb83381eb4d60f59d21a7229ec"
  head "https://github.com/Winetricks/winetricks.git"

  bottle :unneeded

  option "with-zenity", "Zenity is needed for GUI"

  depends_on "cabextract"
  depends_on "p7zip"
  depends_on "unrar"
  depends_on "wine"
  depends_on "zenity" => [:optional, :run]

  def install
    bin.install "src/winetricks"
    man1.install "src/winetricks.1"
  end

  def caveats; <<-EOS.undent
    winetricks is a set of utilities for wine, which is installed separately:
      brew install wine
    EOS
  end

  test do
    system "#{bin}/winetricks", "--version"
  end
end
