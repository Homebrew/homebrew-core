class Zmqpp < Formula
  desc "High-level C++ binding for zeromq"
  homepage "https://zeromq.github.io/zmqpp/"
  url "https://github.com/zeromq/zmqpp/archive/4.2.0.tar.gz"
  sha256 "c1d4587df3562f73849d9e5f8c932ca7dcfc7d8bec31f62d7f35073ef81f4d29"

  bottle do
    cellar :any
    sha256 "69f9c485ca2569e6f2e81e796aae9bb8fc0762857ab23fcadddbfc0188f5c88f" => :high_sierra
    sha256 "b4e7722935e4ee4798e1b175308ea52a0a2c698d07fc5c32363501ee90e03d02" => :sierra
    sha256 "8485c260791953899ef966e0e65104702519310520a790e4a4237f0336df49fa" => :el_capitan
    sha256 "b685138f83319a736cac81faf480f95fd08b4634c8b19e785e611b39ebbfe39c" => :yosemite
    sha256 "9e4a0cf143c037cdc1b5c8440f09ab2b67e79edb78b3b2d638cc4cb523fe7d1b" => :mavericks
    sha256 "2392c3090822256c05a35a2e09e99096512838f51704281a2a3b26af10739813" => :mountain_lion
  end

  depends_on "doxygen" => :build
  depends_on "zeromq"

  needs :cxx11

  def install
    ENV.cxx11

    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    system "doxygen"
    (doc/"html").install Dir.glob("docs/html/*.html")
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
