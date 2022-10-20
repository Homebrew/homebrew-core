class Tdlib < Formula
  desc "Cross-platform library for building Telegram clients"
  homepage "https://core.telegram.org/tdlib"
  url "https://github.com/tdlib/td/archive/v1.8.0.tar.gz"
  sha256 "30d560205fe82fb811cd57a8fcbc7ac853a5b6195e9cb9e6ff142f5e2d8be217"
  license "BSL-1.0"
  head "https://github.com/tdlib/td.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "00e02b03043acd904f3a6422f32e1cef717262c802b1a26bafd392384c392feb"
    sha256 cellar: :any,                 arm64_big_sur:  "8be24a3d5ff903fb42d8a50e1cdf74d15222cecd602f1b94fdf1ca1767ed0937"
    sha256 cellar: :any,                 monterey:       "a2c1f2879ca86f6fc3621b097ebead6145a87d9c4404ceaa52a4506fc8e6d8b5"
    sha256 cellar: :any,                 big_sur:        "7de0871fcfc2f560f2737a017d4466ac9924a275b8b1f812328e23a590eea183"
    sha256 cellar: :any,                 catalina:       "4f83585dd6cc3635b37e93e89db0c939ab0d0e47dff327d2ad5a5357a038777f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2741ee46f0de27c0a2bf4be6ce0c6a0d07d4ef5f7ad51ff5ca726598fb114418"
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
