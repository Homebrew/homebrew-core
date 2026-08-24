class Utf8cpp < Formula
  desc "UTF-8 with C++ in a Portable Way"
  homepage "https://github.com/nemtrif/utfcpp"
  url "https://github.com/nemtrif/utfcpp/archive/refs/tags/v4.2.0.tar.gz"
  sha256 "54a8e96ea835a7359e8e53d03e30e9833d51350cc4615ff53f8449ef19ee46ab"
  license "BSL-1.0"
  version_scheme 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cef5e702293797e4a9a9090c53cac59e979624dbe08e714ac0bbad8632c47bf3"
  end

  depends_on "cmake" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match("PACKAGE_VERSION \"#{version}\"", (share/"utf8cpp/cmake/utf8cppConfigVersion.cmake").read)

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0 FATAL_ERROR)
      project(utf8_append LANGUAGES CXX)
      find_package(utf8cpp REQUIRED CONFIG)
      add_executable(utf8_append utf8_append.cpp)
    CMAKE

    (testpath/"utf8_append.cpp").write <<~CPP
      #include <utf8cpp/utf8.h>
      int main() {
        unsigned char u[5] = {0, 0, 0, 0, 0};
        utf8::append(0x0448, u);
        return (u[0] == 0xd1 && u[1] == 0x88 && u[2] == 0 && u[3] == 0 && u[4] == 0) ? 0 : 1;
      }
    CPP

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_PREFIX_PATH=#{opt_lib}", "-DCMAKE_VERBOSE_MAKEFILE=ON"
    system "cmake", "--build", "build"
    system "./build/utf8_append"
  end
end
