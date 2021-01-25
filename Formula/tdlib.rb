class Tdlib < Formula
  desc "Cross-platform library for building Telegram clients"
  homepage "https://core.telegram.org/tdlib"
  url "https://github.com/tdlib/td/archive/v1.7.0.tar.gz"
  sha256 "3daaf419f1738b7e0ac0e8a08f07e01a1faaf51175a59c0b113c15e30c69e173"
  license "BSL-1.0"
  head "https://github.com/tdlib/td.git"

  bottle do
    cellar :any
    sha256 "79dc39f41a2ad6d8272887c0564f043e9c362b1073ba2ceeb338f50e717c97dc" => :big_sur
    sha256 "15d07ea3abe99c9c65e1e74fa43aa6c2be758e84dc5f8657ef68fc47d8540a36" => :arm64_big_sur
    sha256 "fc606ff0b78fd6ad52f0449dfd1380e646b4de63ff36756546838b783a088ca2" => :catalina
    sha256 "007b08aced0aa457830daaade4299c979ee97db6b420bdfe5d0e6bdd416925c6" => :mojave
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
