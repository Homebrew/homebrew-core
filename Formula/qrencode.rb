class Qrencode < Formula
  desc "QR Code generation"
  homepage "https://fukuchi.org/works/qrencode/index.html.en"
  url "https://fukuchi.org/works/qrencode/qrencode-4.0.2.tar.gz"
  sha256 "dbabe79c07614625d1f74d8c0ae2ee5358c4e27eab8fd8fe31f9365f821a3b1d"

  bottle do
    cellar :any
    sha256 "467f54a970d8ceaceaee214d3723aa4adea9277ecc7c5ccd575da3f7a918af77" => :catalina
    sha256 "1da2c679c176cd636ba258e6f504b35e86b0378f1a97608187b7cc7bb133cc9c" => :mojave
    sha256 "a541a4b376c69168e1d3392c90810893e02bfc1ba235437453018495901a0171" => :high_sierra
    sha256 "9b876f9388c74c61e1d5a3c87663b424c4215e546c37a3a8e1543e5de976988d" => :sierra
    sha256 "83b2cb0f1f60421584a5e6694907ccb636834349a61a40dc8e1a40272a95cc9f" => :el_capitan
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
