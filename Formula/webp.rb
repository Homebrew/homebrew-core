class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "http://downloads.webmproject.org/releases/webp/libwebp-0.5.0.tar.gz"
  sha256 "5cd3bb7b623aff1f4e70bd611dc8dbabbf7688fd5eb225b32e02e09e37dfb274"

  bottle do
    cellar :any
    revision 1
    sha256 "6a3b7bcb3faba322e780726c9d1f9dc4ce3800f1e567099f818d3899e8386dbd" => :el_capitan
    sha256 "d9b26f0db04df6f53b4357efcf329d6c8751238e45c93abe32568272210734cc" => :yosemite
    sha256 "b8b828ea83e78852db35041feb9e16b999b035f4d23a5a51d5be72245eac662d" => :mavericks
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
    system "#{bin}/cwebp", test_fixtures("test.png"), "-o", "webp_test.png"
    system "#{bin}/dwebp", "webp_test.png", "-o", "webp_test.webp"
    assert File.exist?("webp_test.webp")
  end
end
