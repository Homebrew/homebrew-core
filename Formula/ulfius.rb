class Ulfius < Formula
  desc "HTTP Framework for REST Applications in C"
  homepage "https://github.com/babelouest/ulfius/"
  url "https://github.com/babelouest/ulfius/archive/refs/tags/v2.7.12.tar.gz"
  sha256 "20a359eeb30f1807ef68e4b6329fca5a06167eef1f0faaae3d2e0e8e4406bd70"
  license "LGPL-2.1-only"

  depends_on "cmake" => :build
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libmicrohttpd"
  uses_from_macos "curl"

  def install
    mkdir "ulfius-build" do
      args = std_cmake_args
      args += ["-DWITH_JOURNALD=OFF", "-DWITH_WEBSOCKET=on", "-DWITH_GNUTLS=on", "-DWITH_CURL=on"]
      system "cmake", *args, ".."
      system "make", "install"
    end
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
    system ENV.cc, "test.c", "-L#{lib}", "-lulfius", "-o", "test"
    system "./test"
  end
end
