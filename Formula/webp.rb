class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-0.6.1.tar.gz"
  sha256 "06503c782d9f151baa325591c3579c68ed700ffc62d4f5a32feead0ff017d8ab"

  bottle do
    cellar :any
    sha256 "49c01027710cb03d9facc99a6e68f0da43a36f729cad5616df2321bd0306c056" => :high_sierra
    sha256 "f8cadfa3f0ee1b8c95d6a31c85e6ebf8de7fe973788a97aab07172d566183a57" => :sierra
    sha256 "55497d556d3df56d05c37c4459734c5708dead14a62569f4efc5e31307e2f4e7" => :el_capitan
    sha256 "c812d355a21c4bc42a4ecd56781eff5ce5d2ca6d48089b8bbcb83f67814339e0" => :yosemite
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
