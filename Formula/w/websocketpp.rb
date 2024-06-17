class Websocketpp < Formula
  desc "WebSocket++ is a cross platform header only C++ library"
  homepage "https://www.zaphoyd.com/websocketpp"
  url "https://github.com/zaphoyd/websocketpp/archive/refs/tags/0.8.2.tar.gz"
  sha256 "6ce889d85ecdc2d8fa07408d6787e7352510750daa66b5ad44aacb47bea76755"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ce9d34ff864848f173c705dc4eb64b5aaed63fae251ed3e9a4588c46de35e7de"
  end

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <stdio.h>
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
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{Formula["boost"].opt_lib}",
                    "-lboost_random", "-pthread", "-o", "test"
    system "./test"
  end
end
