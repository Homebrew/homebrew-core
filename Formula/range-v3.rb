class RangeV3 < Formula
  desc "Experimental range library for C++14/17/20"
  homepage "https://ericniebler.github.io/range-v3/"
  url "https://github.com/ericniebler/range-v3/archive/0.11.0.tar.gz"
  sha256 "376376615dbba43d3bef75aa590931431ecb49eb36d07bb726a19f680c75e20c"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2500d54ef2231b737505f3cad48f4a3ffb996b3941b8cbee4f8e2b1a44692aec"
    sha256 cellar: :any_skip_relocation, big_sur:       "f22133b9d6ec765bef17f0ad8a81796ceafff1067954eb46a019b63e6aaa4f91"
    sha256 cellar: :any_skip_relocation, catalina:      "bffbe0872b344db9b7838d3a63b10e95df57385d26bfaeffc4da5a3d940893c6"
    sha256 cellar: :any_skip_relocation, mojave:        "bffbe0872b344db9b7838d3a63b10e95df57385d26bfaeffc4da5a3d940893c6"
    sha256 cellar: :any_skip_relocation, high_sierra:   "bffbe0872b344db9b7838d3a63b10e95df57385d26bfaeffc4da5a3d940893c6"
    sha256 cellar: :any_skip_relocation, all:           "946ebe20e9c73966759c6a388c1ac11d08702acb80cd3022354e5fae756eec05"
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
