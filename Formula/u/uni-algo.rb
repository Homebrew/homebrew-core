class UniAlgo < Formula
  desc "Unicode Algorithms Implementation for C/C++"
  homepage "https://github.com/uni-algo/uni-algo"
  url "https://github.com/uni-algo/uni-algo/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "f2a1539cd8635bc6088d05144a73ecfe7b4d74ee0361fabed6f87f9f19e74ca9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "34be3ad63252d36a5233e5ec30f0c13037217de44cff3eb333cfea6fed96e9e2"
    sha256 cellar: :any,                 arm64_sequoia:  "09f9020f24fd9b76bb3639c21fb5b588f3fa92c934a8f372c83ecea0a0bbc2bd"
    sha256 cellar: :any,                 arm64_sonoma:   "f726cbc59189310f80dc73042432149c0dfb8f1f14bdbc215c8ccf94bd4ffa30"
    sha256 cellar: :any,                 arm64_ventura:  "226d0ccf2575a4d4bd3fb85030ce5c49c742796629ca39d49be49e21ca5e976b"
    sha256 cellar: :any,                 arm64_monterey: "6584de32b16dd17dc10b3c191c02571e9a31a3c24874d42463fdb87c8731dc78"
    sha256 cellar: :any,                 sonoma:         "4f671dc3b902289131ad865eccf76b6aede03b6cf9bc3bb46ed50674a6c81efd"
    sha256 cellar: :any,                 ventura:        "8fbf0f7ba2a59794df31d03b58c1e605d321162f54cd2e91a374d4e1414e9f48"
    sha256 cellar: :any,                 monterey:       "760286609376bbe66a454a5d443c40423f7cb4d5cefa55fb4bae09880f1dcdb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a61b42231ce224c3607e3c8e82b193ccd2eacbcee77a5aa4f5666395c539e8ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23987577980bb9edbf0d7a5ddbebaecaedec5ddf44fe0453f02877434fc39d61"
  end

  depends_on "cmake" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(utf8_norm LANGUAGES CXX)
      find_package(uni-algo CONFIG REQUIRED)
      add_executable(utf8_norm utf8_norm.cpp)
      target_link_libraries(utf8_norm PRIVATE uni-algo::uni-algo)
    CMAKE

    (testpath/"utf8_norm.cpp").write <<~CPP
      #include <uni_algo/norm.h>
      int main() {
        return (una::norm::to_nfc_utf8("W\\u0302") == "Ŵ") ? 0 : 1;
      }
    CPP

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_PREFIX_PATH:STRING=#{opt_lib}"
    system "cmake", "--build", "build"
    system "build/utf8_norm"
  end
end
