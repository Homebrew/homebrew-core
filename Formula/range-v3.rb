class RangeV3 < Formula
  desc "Experimental range library for C++11/14/17"
  homepage "https://ericniebler.github.io/range-v3/"
  url "https://github.com/ericniebler/range-v3/archive/0.4.0.tar.gz"
  sha256 "5dbc878b7dfc500fb04b6b9f99d63993a2731ea34b0a4b8d5f670a5a71a18e39"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3135c91c7daa107bd86bd4abe1f3b9973409388307b345274e05d85f6f89bb49" => :mojave
    sha256 "a93d105ccdb20a6fd049ca369eb7eb4732432ed0d71a15a7434c5487209a11ba" => :high_sierra
    sha256 "0332e059707ac24e467f524ce53c034d069c5cc5e9f4f64dac55a09a3c462c7e" => :sierra
    sha256 "0332e059707ac24e467f524ce53c034d069c5cc5e9f4f64dac55a09a3c462c7e" => :el_capitan
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
