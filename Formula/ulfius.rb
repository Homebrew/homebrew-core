class Ulfius < Formula
  desc "HTTP Framework for REST Applications in C"
  homepage "https://github.com/babelouest/ulfius/"
  url "https://github.com/babelouest/ulfius/archive/refs/tags/v2.7.13.tar.gz"
  sha256 "b1679bc0885acedff66abad84b51f492497ab1114d6911d07d2cf7eb77ccadce"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "40fa12cedb5436353fccc44dacd67fab19dcce8fe22440f6f064cc9a39e647f1"
    sha256 cellar: :any,                 arm64_monterey: "ced5108089d089fd93cf9de184c9260a3cd3dd23147b7bed5b2633d25edb1886"
    sha256 cellar: :any,                 arm64_big_sur:  "b1b8019a42955b8e2833bc7593c8fda7e7604cafdbc277a3bd5c690755c61458"
    sha256 cellar: :any,                 ventura:        "71c94a6fe3e1800a700d1966cf241284552a37fd44efe2f6e010bc9325306c5c"
    sha256 cellar: :any,                 monterey:       "c9d813332cc047457f5ef25b1ed68ccf16ceccdffaaa3a3683f121a7bc7c5e1a"
    sha256 cellar: :any,                 big_sur:        "9617ea427778fba53fc1f126177540a1b3b23ed2ba180b045f63c8821c14aba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0763ec79fb970c405df59a59bad803d2910338fe9098bdca35e484d593982e68"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libmicrohttpd"

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
    (testpath/"test.c").write <<~EOS
      #include <ulfius.h>
      int main() {
        struct _u_instance instance;
        ulfius_init_instance(&instance, 8081, NULL, NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lulfius", "-o", "test"
    system "./test"
  end
end
