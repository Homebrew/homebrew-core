class Tdlib < Formula
  desc "Cross-platform library for building Telegram clients"
  homepage "https://core.telegram.org/tdlib"
  url "https://github.com/tdlib/td/archive/v1.7.0.tar.gz"
  sha256 "3daaf419f1738b7e0ac0e8a08f07e01a1faaf51175a59c0b113c15e30c69e173"
  license "BSL-1.0"
  head "https://github.com/tdlib/td.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "65a4a0f8e819d3098b6d27a25094cbdd8f0b52b8b5634d61bc56cab322c69808"
    sha256 cellar: :any,                 arm64_big_sur:  "15d07ea3abe99c9c65e1e74fa43aa6c2be758e84dc5f8657ef68fc47d8540a36"
    sha256 cellar: :any,                 monterey:       "0d8bf2d9dc9fe1cbf2e14e09edad4b925e3c9364dee634a06c91665e9a9885a5"
    sha256 cellar: :any,                 big_sur:        "79dc39f41a2ad6d8272887c0564f043e9c362b1073ba2ceeb338f50e717c97dc"
    sha256 cellar: :any,                 catalina:       "fc606ff0b78fd6ad52f0449dfd1380e646b4de63ff36756546838b783a088ca2"
    sha256 cellar: :any,                 mojave:         "007b08aced0aa457830daaade4299c979ee97db6b420bdfe5d0e6bdd416925c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b31b608f51cf0bf440570fe2eaf172a55816c378a8bfedc69e7625b55f2004b8"
  end

  depends_on "cmake" => :build
  depends_on "gperf" => :build
  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
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
