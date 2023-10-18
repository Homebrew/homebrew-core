class Ulfius < Formula
  desc "HTTP Framework for REST Applications in C"
  homepage "https://github.com/babelouest/ulfius/"
  url "https://github.com/babelouest/ulfius/archive/refs/tags/v2.7.14.tar.gz"
  sha256 "b102cf591ea6526831d72367388bd48dd3ffa3e610513b633ca6cb245dfc07b2"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c23589c595ea8e2582d44852bb275efc34f0a0b5f07ea25bc4884bd81a0b68e2"
    sha256 cellar: :any,                 arm64_ventura:  "a1a1f5a0104338a36e906cf5b924523ab03cd6d5878268972ba43946d4a13d36"
    sha256 cellar: :any,                 arm64_monterey: "4ca55e4d43d20777ccdc5fdd03994a7b7f9598b7d822096a7568e05039adc3e5"
    sha256 cellar: :any,                 arm64_big_sur:  "f9e510b6730cd99ee30ebdefb9d419fbaaf81dd7ebdfec4a48e61c66d51f0170"
    sha256 cellar: :any,                 sonoma:         "861b86fc05a42e91df9665a7410b6f3b746edea07643efdd9e6a13af08892431"
    sha256 cellar: :any,                 ventura:        "29180557a485b14e52eb0ce77cd5da32d8c67da2196ae114f4cd886959e68f6b"
    sha256 cellar: :any,                 monterey:       "cc2bdb9cb2eed70e45849fe984c3bc16748c128e4c78945211f2c22562bd8827"
    sha256 cellar: :any,                 big_sur:        "8d835bfac62dc1f19afa96f993f10e41f642b727fd27b5982122a68ff3b08e95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f46dc90617fa3298530ea2e224185e1a3756b44b85f4048d48649a3d4532c217"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test
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
