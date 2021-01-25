class Winetricks < Formula
  desc "Automatic workarounds for problems in Wine"
  homepage "https://github.com/Winetricks/winetricks"
  url "https://github.com/Winetricks/winetricks/archive/20201206.tar.gz"
  sha256 "2eb5c09e30be942383e242694e654aa294ed2a396e68c68b5eaa17427bd8242b"
  license "LGPL-2.1-or-later"
  head "https://github.com/Winetricks/winetricks.git"

  bottle :unneeded

  depends_on "cabextract"
  depends_on "p7zip"
  depends_on "unzip"

  def install
    bin.install "src/winetricks"
    man1.install "src/winetricks.1"
  end

  test do
    system "#{bin}/winetricks", "--version"
  end
end
