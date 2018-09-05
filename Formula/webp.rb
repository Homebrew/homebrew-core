class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.0.0.tar.gz"
  sha256 "84259c4388f18637af3c5a6361536d754a5394492f91be1abc2e981d4983225b"

  bottle do
    cellar :any
    sha256 "4569dbeeceae346243d7251c0f60e04c4b6c735c4a6c6d3c68dcd66c196d7f65" => :mojave
    sha256 "d84c923512187318d2538983b0c517ae43f8abc9ea4b4dbc80788512ef59f21d" => :high_sierra
    sha256 "a330ed8cf9f841fcebee1cec3c751ed9798d9ecb9481f105ce43cf0adf0e29a9" => :sierra
    sha256 "d1a7a10ea4255d6e0d9930cf0ce42ccb1ba982c128a2830a59c951ce0878a22a" => :el_capitan
  end

  head do
    url "https://chromium.googlesource.com/webm/libwebp.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jpeg"
  depends_on "libpng"

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
