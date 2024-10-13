class Winetricks < Formula
  desc "Automatic workarounds for problems in Wine"
  homepage "https://github.com/Winetricks/winetricks"
  url "https://github.com/Winetricks/winetricks/archive/refs/tags/20240105.tar.gz"
  sha256 "e92929045cf9ffb1e8d16ef8fd971ea1cf63a28a73916b1951e9553c94482f61"
  license "LGPL-2.1-or-later"
  head "https://github.com/Winetricks/winetricks.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d{6,8})$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "5e5a84065b16e964ee5a9cd154fc62d453b54e9ff0b9e8aaf0bf0bcc0fb494bf"
  end

  depends_on "cabextract"
  depends_on "p7zip"
  depends_on "unzip"

  def install
    bin.install "src/winetricks"
    man1.install "src/winetricks.1"
  end

  test do
    system bin/"winetricks", "--version"
  end
end
