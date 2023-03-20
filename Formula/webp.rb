class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.3.0.tar.gz"
  sha256 "64ac4614db292ae8c5aa26de0295bf1623dbb3985054cb656c55e67431def17c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fb2edf5a9f207f41aa11ff72efb0822da454f3a15e633738df8afdf69c40857d"
    sha256 cellar: :any,                 arm64_monterey: "b184d1461126f09e2129f67cbc2025c3fc576f87a76a14bd7b5d76fd1d96a2d0"
    sha256 cellar: :any,                 arm64_big_sur:  "edfeee19efb9e30eb99400eec5017d162ee70fb5d69346fec6f716a5f12c822b"
    sha256 cellar: :any,                 ventura:        "f3f98d19c9ee4f773a937a0d5b44f504710c9f8af29cae6665820a18e2498e97"
    sha256 cellar: :any,                 monterey:       "a07ca47cda0829022148d2b248972f3c37fd53bfbee6b767f8cbbd1a73e5fafe"
    sha256 cellar: :any,                 big_sur:        "84ccd490c545a02910d950ba4b06027685939bec03256abbfbaf012fa02e7a1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89347c4622e958013b7977a06178766cf00d5a98e67acc03163d0c27595cf18f"
  end

  head do
    url "https://chromium.googlesource.com/webm/libwebp.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "giflib"
  depends_on "jpeg-turbo"
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
