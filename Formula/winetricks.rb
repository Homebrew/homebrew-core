class Winetricks < Formula
  desc "Download and install various runtime libraries"
  homepage "https://github.com/Winetricks/winetricks"
  url "https://github.com/Winetricks/winetricks/archive/20170316.tar.gz"
  sha256 "c7a4cf786a634c53e37c129fa7b02085b039e1d110008dac6541e4b9e42f7dae"
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
