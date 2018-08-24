class Zmqpp < Formula
  desc "High-level C++ binding for zeromq"
  homepage "https://zeromq.github.io/zmqpp/"
  url "https://github.com/zeromq/zmqpp/archive/4.2.0.tar.gz"
  sha256 "c1d4587df3562f73849d9e5f8c932ca7dcfc7d8bec31f62d7f35073ef81f4d29"

  bottle do
    cellar :any
    sha256 "dd783ca2b0f191c1a78c60f2c13489fef5d743c8720ed26d5cda6bd8bea32ce9" => :mojave
    sha256 "02c8a7e0124d22e2c9fde2349179d9340e17203ad252ed9fd56fd6c9ea71a24c" => :high_sierra
    sha256 "a1843b77cb53950bcf0b29589071025a48d86f0ecb4420280f7fcff7420f1905" => :sierra
    sha256 "58f0301f03f30b314cb31dbbbc9a82163930b5b00a7285e3d279f49c0e1a25d1" => :el_capitan
  end

  depends_on "doxygen" => :build
  depends_on "zeromq"

  needs :cxx11

  def install
    ENV.cxx11

    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    system "doxygen"
    (doc/"html").install Dir["docs/html/*.html"]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <zmqpp/zmqpp.hpp>
      int main() {
        zmqpp::frame frame;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lzmqpp", "-o", "test", "-std=c++11", "-stdlib=libc++", "-lc++"
    system "./test"
  end
end
