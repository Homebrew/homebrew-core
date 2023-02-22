class Ulfius < Formula
  desc "HTTP Framework for REST Applications in C"
  homepage "https://github.com/babelouest/ulfius/"
  url "https://github.com/babelouest/ulfius/archive/refs/tags/v2.7.13.tar.gz"
  sha256 "b1679bc0885acedff66abad84b51f492497ab1114d6911d07d2cf7eb77ccadce"
  license "LGPL-2.1-only"

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
