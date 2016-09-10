class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "http://downloads.webmproject.org/releases/webp/libwebp-0.5.1.tar.gz"
  # Because Google-hosted upstream URL gets firewalled in some countries.
  mirror "https://dl.bintray.com/homebrew/mirror/webp-0.5.1.tar.gz"
  sha256 "6ad66c6fcd60a023de20b6856b03da8c7d347269d76b1fd9c3287e8b5e8813df"

  bottle do
    cellar :any
    sha256 "d6cbccda27006699d626c2328166f9b7f6953d9340ed16a4d16a14090aa731f0" => :sierra
    sha256 "b110fdb97fa2abeeb6653343dbdf3a7d49d16863623b9884c2088e4e5384560a" => :el_capitan
    sha256 "e345e20c86d54365d313ec9ff498857405b6dc738101c1e9c047d93333395436" => :yosemite
    sha256 "eb44042c412d6701172e5dd2da764041abb523d391b400d136695b5059a9a133" => :mavericks
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
