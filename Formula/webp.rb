class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.2.4.tar.gz"
  sha256 "7bf5a8a28cc69bcfa8cb214f2c3095703c6b73ac5fba4d5480c205331d9494df"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d6cc5a2a21f783077fc0c40e61809d14b52f9c878a682cefe750364222f51551"
    sha256 cellar: :any,                 arm64_monterey: "f2857acd2c645e441e7363903906492e96cda8c52a1fe0c9ddb668fd12f63e53"
    sha256 cellar: :any,                 arm64_big_sur:  "90cc74768d434a5476cf49144d02ef5dd24cfeb2dead12f1210ffa468e024c85"
    sha256 cellar: :any,                 ventura:        "f3f06cd4ebe72b4f991800868e8dc9e6f49f22dccc20ff13fa5c771c3e60f8f2"
    sha256 cellar: :any,                 monterey:       "51401f60176f19559cd04e37873da32c470fe3ac6ba0a9e096a4fafda5cd8065"
    sha256 cellar: :any,                 big_sur:        "dc4045b5b9e114898adc9522c704aa668c15c64a5026a2f22c0edfb0cd5fdaeb"
    sha256 cellar: :any,                 catalina:       "c3d401ed32f666e4b1bf40b7c9c037e4c618e12d9e31b61ae59dca03fb8982a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "853c0c8e2d2b74f0a6f1b7d2b160c3fb69fa7b8a7ae93da5df9da97275a77b8f"
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
