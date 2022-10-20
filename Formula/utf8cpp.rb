class Utf8cpp < Formula
  desc "UTF-8 with C++ in a Portable Way"
  homepage "https://github.com/nemtrif/utfcpp"
  url "https://github.com/nemtrif/utfcpp/archive/v3.2.1.tar.gz"
  sha256 "8d6aa7d77ad0abb35bb6139cb9a33597ac4c5b33da6a004ae42429b8598c9605"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "28ec6ef62b638e29d1dbd3efeef96a3484ad643ad99c5ed2912a6752c25a4f4d"
  end

  depends_on "cmake" => [:build, :test]

  def install
    args = std_cmake_args + %w[
      -DUTF8_INSTALL:BOOL=ON
      -DUTF8_SAMPLES:BOOL=OFF
      -DUTF8_TESTS:BOOL=OFF
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.0.2 FATAL_ERROR)
      project(utf8_append LANGUAGES CXX)
      find_package(utf8cpp REQUIRED CONFIG)
      add_executable(utf8_append utf8_append.cpp)
      target_link_libraries(utf8_append PRIVATE utf8cpp)
    EOS

    (testpath/"utf8_append.cpp").write <<~EOS
      #include <utf8.h>
      int main() {
        unsigned char u[5] = {0, 0, 0, 0, 0};
        utf8::append(0x0448, u);
        return (u[0] == 0xd1 && u[1] == 0x88 && u[2] == 0 && u[3] == 0 && u[4] == 0) ? 0 : 1;
      }
    EOS

    system "cmake", ".", "-DCMAKE_PREFIX_PATH:STRING=#{opt_lib}", "-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON"
    system "make"
    system "./utf8_append"
  end
end
