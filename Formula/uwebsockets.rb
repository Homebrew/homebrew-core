class Uwebsockets < Formula
  desc "Tiny WebSockets"
  homepage "https://gitlab.com/uNetworking/uWebSockets/"
  url "https://github.com/uNetworking/uWebSockets/archive/v0.14.8.tar.gz"
  sha256 "663a22b521c8258e215e34e01c7fcdbbd500296aab2c31d36857228424bb7675"

  depends_on "libuv"
  depends_on "openssl"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <uWS/uWS.h>
      int main() {
          uWS::Hub h;
          h.run();
      }
    EOS
    system ENV.cxx, "-std=c++11",
                    "-I#{Formula["openssl"].opt_include}",
                    "-L#{Formula["openssl"].opt_lib}", "-lssl",
                    "-I#{include}", "-L#{lib}", "-luws",
                    "-I#{Formula["libuv"].opt_include}",
                    "-L#{Formula["libuv"].opt_lib}", "-luv",
                    "-lz", "test.cpp", "-o", "test"
    system "./test"
  end
end
