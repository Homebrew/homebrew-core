class Tdlib < Formula
  desc "Cross-platform library for building Telegram clients"
  homepage "https://core.telegram.org/tdlib"
  url "https://github.com/tdlib/td/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "30d560205fe82fb811cd57a8fcbc7ac853a5b6195e9cb9e6ff142f5e2d8be217"
  license "BSL-1.0"
  head "https://github.com/tdlib/td.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any, arm64_golden_gate: "822250da1da3a72dc4182d90565382875560d1b2d5d5bdc32d9a25960bf3d75f"
    sha256 cellar: :any, arm64_tahoe:       "2e08058c919f73a66663bd6b09489d99b484094d00b71852cb0236abf6d34ae3"
    sha256 cellar: :any, arm64_sequoia:     "6c0cf344b1c403250842e3f2d19abcbf2ce58efe21a3e2b034cc48e38d0627ea"
    sha256 cellar: :any, arm64_linux:       "d9e86f8a0592457c064b7f590b3d95bef3824731a9b4f0a28580071265394a43"
    sha256 cellar: :any, x86_64_linux:      "1c6f55c2a65966ee3490f244aa7ed3bf4ddf3794ae787253415905e8a52f294f"
  end

  depends_on "cmake" => :build
  depends_on "gperf" => :build
  depends_on "openssl@4"
  depends_on "readline"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # Workaround to build with CMake 4
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"tdjson_example.cpp").write <<~CPP
      #include "td/telegram/td_json_client.h"
      #include <iostream>

      int main() {
        void* client = td_json_client_create();
        if (!client) return 1;
        std::cout << "Client created: " << client;
        return 0;
      }
    CPP

    system ENV.cxx, "tdjson_example.cpp", "-L#{lib}", "-ltdjson", "-o", "tdjson_example"
    assert_match "Client created", shell_output("./tdjson_example")
  end
end
