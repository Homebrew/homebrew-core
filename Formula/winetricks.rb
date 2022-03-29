class Winetricks < Formula
  desc "Automatic workarounds for problems in Wine"
  homepage "https://github.com/Winetricks/winetricks"
  url "https://github.com/Winetricks/winetricks/archive/20220328.tar.gz"
  sha256 "e72543f6ddf1283f8290a11d1698c2f91af3db659cec2bfa0c0933ebbc23d777"
  license "LGPL-2.1-or-later"
  head "https://github.com/Winetricks/winetricks.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d{6,8})$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "322c2e6e1dd72073bfb03a230820eb039592c016103d0c442739e9f6c9f3470b"
  end

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
