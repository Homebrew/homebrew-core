class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.0.3.tar.gz"
  sha256 "e20a07865c8697bba00aebccc6f54912d6bc333bb4d604e6b07491c1a226b34f"

  bottle do
    cellar :any
    rebuild 1
    sha256 "38bdac64dbf41666310ae1589e6102b6bcd688540514f7af4334dd74996c4277" => :mojave
    sha256 "b324a2a6eeb5c7c916a903f7249b6233334f99e7394b9927784319f086e21f8e" => :high_sierra
    sha256 "32e6c391ab45b17b167d565ef1ac36eeb2267483425f4b0f710f5445fa75df61" => :sierra
  end

  head do
    url "https://chromium.googlesource.com/webm/libwebp.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

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
