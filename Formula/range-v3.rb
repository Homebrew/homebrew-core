class RangeV3 < Formula
  desc "Experimental range library for C++14/17/20"
  homepage "https://ericniebler.github.io/range-v3/"
  url "https://github.com/ericniebler/range-v3/archive/0.11.0.tar.gz"
  sha256 "376376615dbba43d3bef75aa590931431ecb49eb36d07bb726a19f680c75e20c"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "764f7e1ace531b874b0e1b5e6fd927323fb14e1ba1b53b11e34a65fd9cd2a7db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2500d54ef2231b737505f3cad48f4a3ffb996b3941b8cbee4f8e2b1a44692aec"
    sha256 cellar: :any_skip_relocation, monterey:       "764f7e1ace531b874b0e1b5e6fd927323fb14e1ba1b53b11e34a65fd9cd2a7db"
    sha256 cellar: :any_skip_relocation, big_sur:        "f22133b9d6ec765bef17f0ad8a81796ceafff1067954eb46a019b63e6aaa4f91"
    sha256 cellar: :any_skip_relocation, catalina:       "bffbe0872b344db9b7838d3a63b10e95df57385d26bfaeffc4da5a3d940893c6"
    sha256 cellar: :any_skip_relocation, mojave:         "bffbe0872b344db9b7838d3a63b10e95df57385d26bfaeffc4da5a3d940893c6"
    sha256 cellar: :any_skip_relocation, high_sierra:    "bffbe0872b344db9b7838d3a63b10e95df57385d26bfaeffc4da5a3d940893c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "764f7e1ace531b874b0e1b5e6fd927323fb14e1ba1b53b11e34a65fd9cd2a7db"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

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
    stdlib_ldflag = OS.mac? ? "-lc++" : "-lstdc++"
    flags = [stdlib_ldflag]
    flags << "-stdlib=libc++" if OS.mac?
    system ENV.cc, "test.cpp", "-std=c++14", *flags, "-o", "test"
    assert_equal "h e l l o \n", shell_output("./test")
  end
end
