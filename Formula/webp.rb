class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.0.3.tar.gz"
  sha256 "e20a07865c8697bba00aebccc6f54912d6bc333bb4d604e6b07491c1a226b34f"

  bottle do
    cellar :any
    sha256 "347c02d4de7afe9e5e73391d293a19f89d40957fafd757656011dea270227838" => :mojave
    sha256 "c21dfa59400041f1e1976c3b9721bf10c7df35bf1514f3182d6911db3fb85ebf" => :high_sierra
    sha256 "dd8d1b68c16db0a5861f4be748456fa745dca31e22a708a6eb4f6374b03debbe" => :sierra
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
