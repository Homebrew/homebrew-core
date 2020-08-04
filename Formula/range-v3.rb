class RangeV3 < Formula
  desc "Experimental range library for C++14/17/20"
  homepage "https://ericniebler.github.io/range-v3/"
  url "https://github.com/ericniebler/range-v3/archive/0.10.0.tar.gz"
  sha256 "5a1cd44e7315d0e8dcb1eee4df6802221456a9d1dbeac53da02ac7bd4ea150cd"
  license "BSL-1.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "765e3422e15f7c6e2c3b4d7aacfdfea919ddcad18cde592a481f2eb5e3fe537d" => :catalina
    sha256 "765e3422e15f7c6e2c3b4d7aacfdfea919ddcad18cde592a481f2eb5e3fe537d" => :mojave
    sha256 "765e3422e15f7c6e2c3b4d7aacfdfea919ddcad18cde592a481f2eb5e3fe537d" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".",
                    "-DRANGE_V3_TESTS=OFF",
                    "-DRANGE_V3_HEADER_CHECKS=OFF",
                    "-DRANGE_V3_EXAMPLES=OFF",
                    "-DRANGE_V3_PERF=OFF",
                    *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <range/v3/all.hpp>
      #include <iostream>
      #include <string>

      int main() {
        std::string s{ "hello" };
        ranges::for_each( s, [](char c){ std::cout << c << " "; });
        std::cout << std::endl;
      }
    EOS
    system ENV.cc, "-std=c++14", "-stdlib=libc++", "-lc++",
                   "-o", "test", "test.cpp"
    assert_equal "h e l l o \n", shell_output("./test")
  end
end
