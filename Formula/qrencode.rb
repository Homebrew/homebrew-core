class Qrencode < Formula
  desc "QR Code generation"
  homepage "https://fukuchi.org/works/qrencode/index.html.en"
  url "https://fukuchi.org/works/qrencode/qrencode-4.0.0.tar.gz"
  sha256 "5b621b22931264c7e96c1f9597c3d507d79e059b8207b159fff7547f0b26aa81"

  bottle do
    cellar :any
    sha256 "df4727cb66c9ca501675f7b169ac9c211e7b766a7908c69ee6248536f810bd81" => :sierra
    sha256 "f9bfb2e870776c67d8cfb735ac64162de374d5d123f48e3e3da965cdd742d73a" => :el_capitan
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
