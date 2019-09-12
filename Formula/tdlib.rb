class Tdlib < Formula
  desc "Cross-platform library for building Telegram clients"
  homepage "https://core.telegram.org/tdlib"
  url "https://github.com/tdlib/td/archive/v1.5.0.tar.gz"
  sha256 "ecd30f0261eebbdaa68741bc7e2120fa492c129cb62e2773ab95cc2a789db60e"

  bottle do
    cellar :any
    sha256 "356bbe803158ff34cc20d2610b3e560f21ca87060d9a67daca00373573a29d61" => :mojave
    sha256 "99f59ff5456490402e8391839594bb49b3ca259124415810d33ca8eba38cc77c" => :high_sierra
    sha256 "88f7e8b198a63903fcdb11422199032471400e409d1ffab270b613edb5bbaf6a" => :sierra
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
