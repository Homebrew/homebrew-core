class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.2.3.tar.gz"
  sha256 "f5d7ab2390b06b8a934a4fc35784291b3885b557780d099bd32f09241f9d83f9"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dd0682d7262da6160c7306d8a2e32c9d30ea4f7431e5d17f32c5179e60607f62"
    sha256 cellar: :any,                 arm64_big_sur:  "30cdefea2ff436295ac1154d311f646a360314b0a08c80f6ec20c78a080e29a8"
    sha256 cellar: :any,                 monterey:       "ee3231b25e579ebbc4f31bdb492a660f400357c27351f13945315872f03dbff5"
    sha256 cellar: :any,                 big_sur:        "cb810f94a063ece1fef498631b1409684f8a6191b84aa95794efba528ee1f609"
    sha256 cellar: :any,                 catalina:       "72ece3118d0803094e8e286da12b118dc919f4a3e48fca2ae83b47b10e29da8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93dab01f9143ef3a77e5070e0a4c94652f6cda7031de43020e359def715761d0"
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
