class RangeV3 < Formula
  desc "Experimental range library for C++14/17/20"
  homepage "https://ericniebler.github.io/range-v3/"
  url "https://github.com/ericniebler/range-v3/archive/0.9.1.tar.gz"
  sha256 "2b5b442d572b5978ea51c650adfaf0796f39f326404d09b83d846e04f571876b"

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
    system ENV.cc, "-std=c++14", "-stdlib=libc++", "-lc++",
                   "-o", "test", "test.cpp"
    assert_equal "h e l l o \n", shell_output("./test")
  end
end
