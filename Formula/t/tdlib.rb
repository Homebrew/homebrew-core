class Tdlib < Formula
  desc "Cross-platform library for building Telegram clients"
  homepage "https://core.telegram.org/tdlib"
  url "https://github.com/tdlib/td/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "30d560205fe82fb811cd57a8fcbc7ac853a5b6195e9cb9e6ff142f5e2d8be217"
  license "BSL-1.0"
  head "https://github.com/tdlib/td.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "4fcaff4924fb49375c92b662b6ee8a5271594413b2b2e118a37daf71bbe4b829"
    sha256 cellar: :any,                 arm64_sonoma:   "ee744b1888d6f8e979263e56cf9c1360d6338941f238fc97394762333b13a0fd"
    sha256 cellar: :any,                 arm64_ventura:  "453ae4e6474f7483de288a9f9401e50384dfc4e094fe34f4f6927d0868f1c53c"
    sha256 cellar: :any,                 arm64_monterey: "d63a391500b354be858ea542555e32e5bcbf25e1c5b6e5ce6fb1fc9caa383b1f"
    sha256 cellar: :any,                 arm64_big_sur:  "d89f1c5d42063c1c787d8bdacef1d4a7f508e4f480f65f55412fa2c6d85ae01d"
    sha256 cellar: :any,                 sonoma:         "0cd87bf5abd70cab87e71bb9507ccdbda13b064acce240f573585dbd3935995b"
    sha256 cellar: :any,                 ventura:        "a18fe5ac33ffbd29734e6a811a4a5f00303487c1a63bce58b9d5a05e0b161e06"
    sha256 cellar: :any,                 monterey:       "f445c63b3ebc517e25008bc5eefe5cb631e9fbdac5f80530e292270be44bee25"
    sha256 cellar: :any,                 big_sur:        "e005fffee17a01c0deb9d1cf6afc29fb3d997bbb56391c3fc5b5d70b52503a8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "763e767a1c640428361a506075089ca11a7f2e930dd315137968bc359ab901d1"
  end

  depends_on "cmake" => :build
  depends_on "gperf" => :build
  depends_on "openssl@3"
  depends_on "readline"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
