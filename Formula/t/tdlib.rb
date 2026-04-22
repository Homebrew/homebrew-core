class Tdlib < Formula
  desc "Cross-platform library for building Telegram clients"
  homepage "https://github.com/tdlib/td"
  url "https://github.com/tdlib/td/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "30d560205fe82fb811cd57a8fcbc7ac853a5b6195e9cb9e6ff142f5e2d8be217"
  license "BSL-1.0"
  head "https://github.com/tdlib/td.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "9d1fd3dd4b4f6f6dd59c2e1534e86d48321e922ab731ac2f1fdefc1af67a10c1"
    sha256 cellar: :any,                 arm64_sequoia: "7cb6fd775b4dbe3570749cb293e59813c6374078c7f51ef1edc3c92faa35e492"
    sha256 cellar: :any,                 arm64_sonoma:  "623df62e47d351af45a941e704ced66b97abf7a6a54cdc0fd065f4f0bbd5d5c8"
    sha256 cellar: :any,                 sonoma:        "625b06e1fb521c8e2dae96cc5715b0a9cf5c80714a2ff1c92eff9166784e4a30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5db1c940a4cbf27205ab7bf666196ae0951d38661ecab0df338a6b0a8c548e46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c71a6f6d59ab8bb956483673fafbe5666e111856596661c6a3ebd210e1212ab4"
  end

  depends_on "cmake" => :build
  depends_on "gperf" => :build
  depends_on "openssl@3"
  depends_on "readline"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
