class RangeV3 < Formula
  desc "Experimental range library for C++11/14/17"
  homepage "https://ericniebler.github.io/range-v3/"
  url "https://github.com/ericniebler/range-v3/archive/0.4.0.tar.gz"
  sha256 "5dbc878b7dfc500fb04b6b9f99d63993a2731ea34b0a4b8d5f670a5a71a18e39"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9f7e57576943c1786a6d5776d31dfe594a6d88de7dd5cefe0bb48f7481863b1" => :mojave
    sha256 "8d44dcaec99ccbf6fcae8c2ecff860481a6b43900a96f8a24e9a1392e7d46fd7" => :high_sierra
    sha256 "8d44dcaec99ccbf6fcae8c2ecff860481a6b43900a96f8a24e9a1392e7d46fd7" => :sierra
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
    system ENV.cc, "-std=c++11", "-stdlib=libc++", "-lc++",
                   "-o", "test", "test.cpp"
    assert_equal "h e l l o \n", shell_output("./test")
  end
end
