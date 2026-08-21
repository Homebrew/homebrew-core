class Zmqpp < Formula
  desc "High-level C++ binding for zeromq"
  homepage "https://zeromq.github.io/zmqpp/"
  url "https://github.com/zeromq/zmqpp/archive/refs/tags/4.2.0.tar.gz"
  sha256 "c1d4587df3562f73849d9e5f8c932ca7dcfc7d8bec31f62d7f35073ef81f4d29"
  license "MPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "3ac4227c4c1cde3e4032814d10d46ffd02c9e4e8df17eb19836b267bea0144ff"
    sha256 cellar: :any, arm64_sequoia: "d3a792c4cdb47f17ad6f21a29cc4149a9746803934d20a526a4ba46aa2275b63"
    sha256 cellar: :any, arm64_sonoma:  "7ac1c634bdeee6ebbc76593a5a4f8e39fd70a0126c1c45b57d3768685830b31c"
    sha256 cellar: :any, sonoma:        "ae8df354a2128a41ede4bb01a68b8cf9da22f4e7218846eecce6d7cb83f01f35"
    sha256 cellar: :any, arm64_linux:   "5d8bd00d12688b681d10e6d679c345c8e01ee5cf2ad429b677bff8b8f66e2e63"
    sha256 cellar: :any, x86_64_linux:  "d9900698234c1c425ee7aecbef428841f38ccf302af72ef3a2f3426e8aa7dd21"
  end

  depends_on "zeromq"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <zmqpp/zmqpp.hpp>
      int main() {
        zmqpp::frame frame;
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lzmqpp", "-o", "test", "-std=c++11"
    system "./test"
  end
end
