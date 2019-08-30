class Tdlib < Formula
  desc "Cross-platform library for building Telegram clients"
  homepage "https://core.telegram.org/tdlib"
  url "https://github.com/tdlib/td/archive/v1.4.0.tar.gz"
  sha256 "673e3b5d362edaed6bb016d2e674540644d66ded68556f32dfec0d5e1544532c"
  revision 1

  bottle do
    cellar :any
    sha256 "43d05fa9669a385041355dc2589b3c79c0e4eb865f2c4ce684c3cf9bfa1a90ad" => :mojave
    sha256 "2045c65dbb9580bd1c6c3dcd648596f6fe0fdaf12eebf661e594892c5bb2e17c" => :high_sierra
    sha256 "9d96510be1b5d37b9775cc039eabebf6b62e66b26f1259e841a5be1f223d9957" => :sierra
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
