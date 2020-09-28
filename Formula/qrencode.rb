class Qrencode < Formula
  desc "QR Code generation"
  homepage "https://fukuchi.org/works/qrencode/index.html.en"
  url "https://fukuchi.org/works/qrencode/qrencode-4.1.1.tar.gz"
  sha256 "da448ed4f52aba6bcb0cd48cac0dd51b8692bccc4cd127431402fca6f8171e8e"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://fukuchi.org/works/qrencode/"
    regex(/href=.*?qrencode[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "2cc7a1c318d30f1e1fd9a79975f28b0ae17b982e6252e632ef31ad10eb8559cf" => :catalina
    sha256 "becf48027c78b7b5a21121cfe19a21adb6cad2f9a3692ade37ddcfe9e737de87" => :mojave
    sha256 "e40f0dcb310095f0d90dff2b1a7ecb17fd94c364b776b3c29a4dfe214df95fdf" => :high_sierra
  end

  head do
    url "https://github.com/fukuchi/libqrencode.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/qrencode", "123456789", "-o", "test.png"
  end
end
