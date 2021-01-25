class Utf8cpp < Formula
  desc "UTF-8 with C++ in a Portable Way"
  homepage "https://github.com/nemtrif/utfcpp"
  url "https://github.com/nemtrif/utfcpp/archive/v3.1.2.tar.gz"
  sha256 "fea3bfa39fb8bd7368077ea5e1e0db9a8951f7e6fb6d9400b00ab3d92b807c6d"
  license "BSL-1.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a8248499ba22f0297020be8647f9a31601f288a67301618f2d53b1dd323c75a" => :big_sur
    sha256 "1a2e11d78a9dc402debeddd7ece934e3474f5d14c13919b4ec1d7648bbc1a5dc" => :arm64_big_sur
    sha256 "a0fa75e69c89763a208e702c4c9c60199596305db62666940a15cecd65de2a2e" => :catalina
    sha256 "d90fa3e80a1b718889cc44d54a55790051bd919f3733ad124fdab15ea16ed9c6" => :mojave
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
