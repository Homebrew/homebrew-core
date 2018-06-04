class Qrencode < Formula
  desc "QR Code generation"
  homepage "https://fukuchi.org/works/qrencode/index.html.en"
  url "https://fukuchi.org/works/qrencode/qrencode-4.0.1.tar.gz"
  sha256 "ac6ba95e5955b5a68be2c8fc208593ddba1d6a3e6eb74b65ff6ee46ab2e5b65b"

  bottle do
    cellar :any
    sha256 "bb786e4a5139fc1d3e3615139438c1b098a9c3e06ac5f5879784b617899b90c4" => :high_sierra
    sha256 "979e9d143753bada53e98ce8b27683ee6d4132d0cc7138085b18e2f90636d78b" => :sierra
    sha256 "c18a70b2d84e2020ade3cbc40b3f37ed86b07249a2b5e8c88c8650debf7aa337" => :el_capitan
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
