class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "http://downloads.webmproject.org/releases/webp/libwebp-0.5.2.tar.gz"
  # Because Google-hosted upstream URL gets firewalled in some countries.
  mirror "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-0.5.2.tar.gz"
  sha256 "b75310c810b3eda222c77f6d6c26b061240e3d9060095de44b2c1bae291ecdef"

  bottle do
    cellar :any
    sha256 "91f25987f2285b5c0cb207ce1140a7713a4dfc4225647d2a66068d008232b0f4" => :sierra
    sha256 "7fa34bf3080e7d5928d55fbf4a1dd02c3bad77c28438598ece378ce03092848d" => :el_capitan
    sha256 "138af3c079cb9d542297295a69026cb44e4cdf132ccddb97dbc7439d3b8d6736" => :yosemite
  end

  head do
    url "https://chromium.googlesource.com/webm/libwebp.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "libpng"
  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :optional
  depends_on "giflib" => :optional

  def install
    system "./autogen.sh" if build.head?

    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-gl",
                          "--enable-libwebpmux",
                          "--enable-libwebpdemux",
                          "--enable-libwebpdecoder",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"cwebp", test_fixtures("test.png"), "-o", "webp_test.png"
    system bin/"dwebp", "webp_test.png", "-o", "webp_test.webp"
    assert File.exist?("webp_test.webp")
  end
end
