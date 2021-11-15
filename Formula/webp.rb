class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.2.1.tar.gz"
  sha256 "808b98d2f5b84e9b27fdef6c5372dac769c3bda4502febbfa5031bd3c4d7d018"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ffa72449868fe57e0f0569029599a16560655ced5608647c89ca6d387452d353"
    sha256 cellar: :any,                 arm64_big_sur:  "5ce68fe9924fd7797ec5abcfd702e19cc1cccebd98e7f1d80e03858908c741d4"
    sha256 cellar: :any,                 monterey:       "6c0016464b96910b886a0f1d8f179d352f2a2dddae3554a0a6e1e52f2edac78e"
    sha256 cellar: :any,                 big_sur:        "f899dc2f56658f6c0481800f20e260084e3ec38c7a8b3ee8de59553b4d7e146d"
    sha256 cellar: :any,                 catalina:       "9782ff133700cc676327f9f1046c9d3b01e5179345d315734593df79dcb70e2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00e8b65d83b94cd68e3d1340ef654381c6dfa7122a9b3fd239d7055414081f54"
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
