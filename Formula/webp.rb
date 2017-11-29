class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-0.6.1.tar.gz"
  sha256 "06503c782d9f151baa325591c3579c68ed700ffc62d4f5a32feead0ff017d8ab"

  bottle do
    cellar :any
    sha256 "f42744b43febbc4a5d8cac83c87c0aee99c5c1cf7306beb9ed1811be702b318b" => :high_sierra
    sha256 "d4c014af0a6786cad79a22c9310b36704682df1fddb7f34bf887aaea27fdd531" => :sierra
    sha256 "ac9503f2951034f2cad4dec141c11d564580a622d916c152788a4e3f3116b0ba" => :el_capitan
  end

  head do
    url "https://chromium.googlesource.com/webm/libwebp.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libpng"
  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :optional
  depends_on "giflib" => :optional

  def install
    args = [
      "--disable-dependency-tracking",
      "--disable-gl",
      "--enable-libwebpmux",
      "--enable-libwebpdemux",
      "--enable-libwebpdecoder",
      "--prefix=#{prefix}",
    ]
    args << "--disable-gif" if build.without? "giflib"
    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"cwebp", test_fixtures("test.png"), "-o", "webp_test.png"
    system bin/"dwebp", "webp_test.png", "-o", "webp_test.webp"
    assert_predicate testpath/"webp_test.webp", :exist?
  end
end
