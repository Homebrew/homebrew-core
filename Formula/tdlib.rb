class Tdlib < Formula
  desc "Cross-platform library for building Telegram clients"
  homepage "https://core.telegram.org/tdlib"
  url "https://github.com/tdlib/td/archive/v1.7.0.tar.gz"
  sha256 "3daaf419f1738b7e0ac0e8a08f07e01a1faaf51175a59c0b113c15e30c69e173"
  license "BSL-1.0"
  head "https://github.com/tdlib/td.git"

  bottle do
    cellar :any
    sha256 "5a739f9199a7f9f24fdc70afdbc632ab23ae84b2a3d67fafcffc2bcc5273832c" => :big_sur
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
