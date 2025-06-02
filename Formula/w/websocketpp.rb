class Websocketpp < Formula
  desc "WebSocket++ is a cross platform header only C++ library"
  homepage "https://www.zaphoyd.com/websocketpp"
  url "https://github.com/zaphoyd/websocketpp/archive/refs/tags/0.8.2.tar.gz"
  sha256 "6ce889d85ecdc2d8fa07408d6787e7352510750daa66b5ad44aacb47bea76755"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "782e6a1f87776d26f0aa59cecb2413a4e1b69291cfe5feadb07614138280ef11"
  end

  # cannot run with asio 1.34.2, upstream issue, https://github.com/zaphoyd/websocketpp/issues/1169
  # no commits in the past five years
  deprecate! date: "2025-04-10", because: :unmaintained

  depends_on "cmake" => :build
  depends_on "asio"

  def install
    # cmake 4.0 support PR, https://github.com/zaphoyd/websocketpp/pull/1168
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <stdio.h>
      #define ASIO_STANDALONE
      #include <websocketpp/config/asio_no_tls_client.hpp>
      #include <websocketpp/client.hpp>
      typedef websocketpp::client<websocketpp::config::asio_client> client;
      int main(int argc, char ** argv)
      {
        client c;
        try {
          c.init_asio();
          return 0;
        } catch (websocketpp::exception const & e) {
          std::cout << e.what() << std::endl;
          return 1;
        }
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++11", "-pthread", "-o", "test"
    system "./test"
  end
end
