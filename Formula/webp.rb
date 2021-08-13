class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.2.1.tar.gz"
  sha256 "808b98d2f5b84e9b27fdef6c5372dac769c3bda4502febbfa5031bd3c4d7d018"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "dd6e09db88a5d8a1317ea461fafe7e6e3e92e0ef4885c2e8a6a70a1a44d00a91"
    sha256 cellar: :any,                 big_sur:       "1099da9d890c863542eb14e0de9f82b20ffbd9b869da33230f76adc8fa70579c"
    sha256 cellar: :any,                 catalina:      "dc30946a7cf3bee45f279a2886d54d7b5c3d7253ba4e0728d49341d26573ed14"
    sha256 cellar: :any,                 mojave:        "31d671e9218539c8b2671b14b8c5f09b58b6d711469dd13da729fa33f61fddb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3f117152641c89ca4441f45545e848cd0117006bc3ea2e415224cc5ea400cd8"
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
