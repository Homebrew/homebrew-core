class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.2.2.tar.gz"
  sha256 "7656532f837af5f4cec3ff6bafe552c044dc39bf453587bd5b77450802f4aee6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "44dfabbbc585237b1f52d517186ec33ea0f65398667559a5164d0013881ded77"
    sha256 cellar: :any,                 arm64_big_sur:  "9b8ae542d86b3faa7cf531d1cb2d1a410a55ece8d635302b783d122702ba3246"
    sha256 cellar: :any,                 monterey:       "58169ef7b31ed2980685c05a7fc1d874a67802f7be0def4c295135ee73796d11"
    sha256 cellar: :any,                 big_sur:        "3f1bdbf8361bdcb55d722c0007e4056e7a535234b8e7fe0cff6016dc48e1c8a9"
    sha256 cellar: :any,                 catalina:       "5cf57e838f218193d7543de1b50093185e72fa368b7334a3ee58ea4b2268e994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10c1f70224b629c8eb550469e51379c29f0996bd87690304f3c226a1fb930677"
  end

  head do
    url "https://chromium.googlesource.com/webm/libwebp.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "giflib"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
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
