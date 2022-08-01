class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.2.3.tar.gz"
  sha256 "f5d7ab2390b06b8a934a4fc35784291b3885b557780d099bd32f09241f9d83f9"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c421bfcdd0b6e294554c8db1361880f1c2336421f33d7429b5e2882635982599"
    sha256 cellar: :any,                 arm64_big_sur:  "0174c48cd6b6ef60529d9ed22f38d871d80e70a2b23fcebdbfc269b47e7218e5"
    sha256 cellar: :any,                 monterey:       "aeb7b8d7d4e6738c171d8078205ffbfa9ccfe3aa03436b564b34febc816d5274"
    sha256 cellar: :any,                 big_sur:        "f8ee3c889b0f61ce396fc6e3bd37a0511168c144f2519ad6372e062d0f23c1cd"
    sha256 cellar: :any,                 catalina:       "708e35dfe3d8e88b996d74dc0b7447e4a1df708515c0b4f6fc9b41c959e351a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0d531bfdd8cb06b09a60e07bd731d8f9a50e90f15cf26623b45e47adecdf577"
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
