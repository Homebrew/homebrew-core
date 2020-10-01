class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://www.scummvm.org/frs/scummvm-tools/2.2.0/scummvm-tools-2.2.0.tar.xz"
  sha256 "1e72aa8f21009c1f7447c755e7f4cf499fe9b8ba3d53db681ea9295666cb48a4"
  license "GPL-2.0"
  head "https://github.com/scummvm/scummvm-tools.git"

  livecheck do
    url "https://www.scummvm.org/downloads/"
    regex(/href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "821010b2b6e9756d7207a5dd61cdac53c82b780ca9a17a8ae313f82501cfa5fb" => :catalina
    sha256 "47718a761f38f31677a6a02851be2b42e16fb891bdb02df704f32d8b84e93796" => :mojave
    sha256 "9f5a6820cf016444c995abd59119e7446b5b9342298b97b9767efbd8938a2579" => :high_sierra
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
