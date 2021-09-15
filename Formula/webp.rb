class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.2.1.tar.gz"
  sha256 "808b98d2f5b84e9b27fdef6c5372dac769c3bda4502febbfa5031bd3c4d7d018"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "20c16f99690230e4ea9ba7a15fe9c482d56baa2f893261de8d785a8ff88c6171"
    sha256 cellar: :any,                 big_sur:       "82435d74c96ff1a8482981458f110a9526472e452968e2969e37dc6b48fbe3e5"
    sha256 cellar: :any,                 catalina:      "43953ec86a790330c17c714d88087f0388c739f6a15be2ae18480e397df25d61"
    sha256 cellar: :any,                 mojave:        "372e3ce46f089e0ae89fcdc62a8f360634dabcedeabade508d8cc7fd4fd6405c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af503080f936897776b59b9000e3e230c76e1eb694cf6f8366fa776f5207b75a"
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
