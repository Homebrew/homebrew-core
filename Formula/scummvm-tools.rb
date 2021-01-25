class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://www.scummvm.org/frs/scummvm-tools/2.2.0/scummvm-tools-2.2.0.tar.xz"
  sha256 "1e72aa8f21009c1f7447c755e7f4cf499fe9b8ba3d53db681ea9295666cb48a4"
  license "GPL-2.0-or-later"
  head "https://github.com/scummvm/scummvm-tools.git"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "4b1a47fd6bd0890f4c10b2feb784b5c2cece304cfd106bd214ce8233688e72a3" => :big_sur
    sha256 "4d43c5933986b4c011c5cf9f45bd853cf0faabb652aab2ce53f9e5cfc5d95ae0" => :catalina
    sha256 "64cce3aa4cfbb11ee9223bb1037cf85e8cec3ab78d2206aeb93f2605ea7cf327" => :mojave
    sha256 "0c207fc3e8ee9b54b1c6f85d1461458cbe3ba05b591f87807ff4e534c4baec17" => :high_sierra
  end

  depends_on "boost"
  depends_on "flac"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "wxmac"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/scummvm-tools-cli", "--list"
  end
end
