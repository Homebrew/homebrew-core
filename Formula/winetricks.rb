class Winetricks < Formula
  desc "Download and install various runtime libraries"
  homepage "https://github.com/Winetricks/winetricks"
  url "https://github.com/Winetricks/winetricks/archive/20180513.tar.gz"
  sha256 "626aff64e3d93698704b0b668225d5504fd8ef556e3834f569058deaeafada8e"
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

  def caveats; <<~EOS
    winetricks is a set of utilities for wine, which is installed separately:
      brew install wine
    EOS
  end

  test do
    system "#{bin}/winetricks", "--version"
  end
end
