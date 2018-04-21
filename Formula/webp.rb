class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.0.0.tar.gz"
  sha256 "84259c4388f18637af3c5a6361536d754a5394492f91be1abc2e981d4983225b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "2c63cdd23bae03c269bf2fadff581e2f3788ebab43f188d4454e9f911dd3071f" => :high_sierra
    sha256 "fd285108001d5fb22f89c0b1069edc24c0895cce236e9d2d2fa0ff36e5cad47c" => :sierra
    sha256 "348bfe8d95c7234a17ad48b1cd36ba50085eb0b4a1600e67a91e0699276e371a" => :el_capitan
  end

  head do
    url "https://chromium.googlesource.com/webm/libwebp.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jpeg"
  depends_on "libpng"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-gif",
                          "--disable-gl",
                          "--enable-libwebpdecoder",
                          "--enable-libwebpdemux",
                          "--enable-libwebpmux"
    system "make", "install"
  end

  test do
    system bin/"cwebp", test_fixtures("test.png"), "-o", "webp_test.png"
    system bin/"dwebp", "webp_test.png", "-o", "webp_test.webp"
    assert_predicate testpath/"webp_test.webp", :exist?
  end
end
