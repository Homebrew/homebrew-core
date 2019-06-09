class RangeV3 < Formula
  desc "Experimental range library for C++11/14/17"
  homepage "https://ericniebler.github.io/range-v3/"
  url "https://github.com/ericniebler/range-v3/archive/0.5.0.tar.gz"
  sha256 "32e30b3be042246030f31d40394115b751431d9d2b4e0f6d58834b2fd5594280"

  bottle do
    cellar :any_skip_relocation
    sha256 "bfce29e300648cd129d6a60754e39f4913718ed1a1aafa290b779ef6a4912586" => :mojave
    sha256 "bfce29e300648cd129d6a60754e39f4913718ed1a1aafa290b779ef6a4912586" => :high_sierra
    sha256 "7f9d9f067016eba85467dc70bf41124351b5d994d6b751ec97d4b81c0c064b65" => :sierra
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
