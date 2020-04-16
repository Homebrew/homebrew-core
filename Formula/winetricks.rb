class Winetricks < Formula
  desc "Automatic workarounds for problems in Wine"
  homepage "https://github.com/Winetricks/winetricks"
  url "https://github.com/Winetricks/winetricks/archive/20200412.tar.gz"
  sha256 "4b0aa4f11dbc30d10a8edd2bb83fcc34f9b143ab58ccce7b99cd54ebff7ec260"
  head "https://github.com/Winetricks/winetricks.git"

  bottle :unneeded

  depends_on "cabextract"
  depends_on "p7zip"
  depends_on "unrar"

  def install
    bin.install "src/winetricks"
    man1.install "src/winetricks.1"
  end

  test do
    system "#{bin}/winetricks", "--version"
  end
end
