class Tdlib < Formula
  desc "Cross-platform library for building Telegram clients"
  homepage "https://core.telegram.org/tdlib"
  url "https://github.com/tdlib/td/archive/v1.3.0.tar.gz"
  sha256 "2953fe75027ac531248b359123aa4812666377ac874c1db506fa74176f2d2338"

  depends_on "cmake" => :build
  depends_on "gperf"
  depends_on "openssl"
  depends_on "readline"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"tdjson_example.cpp").write <<~EOS
      #include "td/telegram/td_json_client.h"
      #include <iostream>

      int main() {
        void* client = td_json_client_create();
        if (!client) return 1;
        std::cout << "Client created: " << client;
        return 0;
      }
    EOS

    system ENV.cxx, "tdjson_example.cpp", "-L#{lib}", "-ltdjson", "-o", "tdjson_example"
    assert_match "Client created", shell_output("./tdjson_example")
  end
end
