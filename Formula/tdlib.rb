class Tdlib < Formula
  desc "Cross-platform library for building Telegram clients"
  homepage "https://core.telegram.org/tdlib"
  url "https://github.com/tdlib/td/archive/v1.5.0.tar.gz"
  sha256 "ecd30f0261eebbdaa68741bc7e2120fa492c129cb62e2773ab95cc2a789db60e"

  bottle do
    cellar :any
    sha256 "99bba47b0129e9654b18c60386e138c33f71454aa662886c9366a043b7802528" => :catalina
    sha256 "9be0460254a6d1c705c48703fa4acd66ced464e3966d29cde49b82738806ce5b" => :mojave
    sha256 "7d3964bf0288801a360288458d604ab60ed414393d77d674913e93156fa3cb55" => :high_sierra
    sha256 "891c74200c0053cef624e5521b4ec576cd2c133e41433fd16ea42dac0b6672d0" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "gperf"
  depends_on "openssl@1.1"
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
