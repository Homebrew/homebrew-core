class Winetricks < Formula
  desc "Download and install various runtime libraries"
  homepage "https://github.com/Winetricks/winetricks"
  url "https://github.com/Winetricks/winetricks/archive/20170614.tar.gz"
  sha256 "c31a51b006511b0ee47c662ef0ef98dd77c6ae410b083927c27674200974d173"
  head "https://github.com/Winetricks/winetricks.git"

  bottle :unneeded

  option "with-zenity", "Zenity is needed for GUI"

  depends_on "cabextract"
  depends_on "p7zip"
  depends_on "unrar"
  depends_on "wine" => :optional
  depends_on "zenity" => :optional

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
