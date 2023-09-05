class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.3.1.tar.gz"
  sha256 "b3779627c2dfd31e3d8c4485962c2efe17785ef975e2be5c8c0c9e6cd3c4ef66"
  license "BSD-3-Clause"
  head "https://chromium.googlesource.com/webm/libwebp.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "e0c538599934578a095d50ac8cff270b99ab970a1c2ceaf53fd2eba455d30f4b"
    sha256 cellar: :any,                 arm64_monterey: "7a5300bd253231e26cf1a812e632f640fe70c70968de3983ef52dfa173d21fd8"
    sha256 cellar: :any,                 arm64_big_sur:  "aa41b5ef22068f33e787fccad19f53d5c1e612868f51f91c07503dd425ff67dd"
    sha256 cellar: :any,                 ventura:        "e0d959ce6788af805576cd5c49271db304f54072c2d05cd01afbb461be49f4e3"
    sha256 cellar: :any,                 monterey:       "44e32d5960d8b8145b6d0fc81e77488ccb556031ae333d43a17183de65c70b1d"
    sha256 cellar: :any,                 big_sur:        "1fd3848cd6eed116775e46cc84000e3247d725f5b063cfc6590a35ad6ad9904e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4438642d7dd479d38f96638500e9465725ff5416df2bd582abc60e8cd6cbfdf1"
  end

  depends_on "cmake" => :build
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF", *args
    system "cmake", "--build", "static"
    lib.install buildpath.glob("static/*.a")
  end

  test do
    system bin/"cwebp", test_fixtures("test.png"), "-o", "webp_test.png"
    system bin/"dwebp", "webp_test.png", "-o", "webp_test.webp"
    assert_predicate testpath/"webp_test.webp", :exist?
  end
end
