class Utf8cpp < Formula
  desc "UTF-8 with C++ in a Portable Way"
  homepage "https://github.com/nemtrif/utfcpp"
  url "https://github.com/nemtrif/utfcpp/archive/v3.2.4.tar.gz"
  sha256 "fde21a4c519eed25f095a1cd8490167409cc70d7b5e9c38756142e588ccb7c7e"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9cb863de843378bed416d75ace5a55d4cc5547bbaf86ecb7ad721ace8c92d2f9"
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
