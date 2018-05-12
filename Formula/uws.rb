class Uws < Formula
  desc "Tiny WebSockets"
  homepage "https://github.com/uNetworking/uWebSockets"
  url "https://github.com/uNetworking/uWebSockets/archive/v0.14.7.tar.gz"
  sha256 "dcf050aa642c1a68e19fd3d9343f52e29179aa88dd2253a875842a76795671e9"

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
