class Ulfius < Formula
  desc "HTTP Framework for REST Applications in C"
  homepage "https://babelouest.github.io/ulfius/"
  url "https://github.com/babelouest/ulfius/archive/refs/tags/v2.7.15.tar.gz"
  sha256 "19cf789b2af1919b69f77c7701237bfc318a9781ec657b68fd4b6ffa9d53f111"
  license "LGPL-2.1-only"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "a535c2a3e95d6f0a6d9426b4bebb34b17337aa1d2eb3352464c00c01062f8bad"
    sha256 cellar: :any,                 arm64_sequoia:  "6020a868ce69b336b8ef6dd3b37bd70cd21eb8a246ddae1ae45a9b713b672e42"
    sha256 cellar: :any,                 arm64_sonoma:   "453e5f09539969edae37b6aeafbe2165a455a91b12df2d0c4920d7db20b20ced"
    sha256 cellar: :any,                 arm64_ventura:  "4ba9e5737a26c0feece3bfe0ab61c5e48668352323c32d6be741ee7e210b23ff"
    sha256 cellar: :any,                 arm64_monterey: "7729359e1306b5f7a7d1a7624cbe743002f67b4e59d61f681e48c9e1f226b599"
    sha256 cellar: :any,                 sonoma:         "4b5da848abed1816659dd597ccc41309b3c1203b2995cad5cf2db0300f9dd2b2"
    sha256 cellar: :any,                 ventura:        "4441a18184afaf2dd7455d10c927106aff533171586db43327aebe25ae58b6e9"
    sha256 cellar: :any,                 monterey:       "668f26af0904892c71317dee876e011e9caa179dda3b1f242db74d1387de74e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c35e214b85f1734b4d5fe4fcaf6ff18d6ab1f0b9253ec7801c9518a2c44f48d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaf71e924637028cb1e0510ac9e58eeff98e0958fd0662bc593e60855dba652d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libmicrohttpd"
  depends_on "orcania"
  depends_on "yder"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    args = %W[
      -DWITH_JOURNALD=OFF
      -DWITH_WEBSOCKET=on
      -DWITH_GNUTLS=on
      -DWITH_CURL=on
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "ulfius-build", *args, *std_cmake_args
    system "cmake", "--build", "ulfius-build"
    system "cmake", "--install", "ulfius-build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <ulfius.h>
      int main() {
        struct _u_instance instance;
        ulfius_init_instance(&instance, 8081, NULL, NULL);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lulfius", "-o", "test"
    system "./test"
  end
end
