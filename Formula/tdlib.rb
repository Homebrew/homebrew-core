class Tdlib < Formula
  desc "Cross-platform library for building Telegram clients"
  homepage "https://core.telegram.org/tdlib"
  url "https://github.com/tdlib/td/archive/v1.6.0.tar.gz"
  sha256 "9dce57a96f9d4bac8f99aab13ef5cbf6fed04b234a5d22dfa7ef7dce06ea43f8"
  license "BSL-1.0"

  bottle do
    cellar :any
    sha256 "c1a28a0f9a80fb62b6ac8a30fffcaf413336e9df49f79f9f952ae38c8840becf" => :catalina
    sha256 "08507a9bf3c9f93ff97666fe9478398768f135e7943145a82946e008acf543e7" => :mojave
    sha256 "12ce0917663736dc4790482c5545a6bee2b82dd7b304ab401c4232ba5d14a3f3" => :high_sierra
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
