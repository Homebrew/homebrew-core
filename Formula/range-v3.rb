class RangeV3 < Formula
  desc "Experimental range library for C++14/17/20"
  homepage "https://ericniebler.github.io/range-v3/"
  url "https://github.com/ericniebler/range-v3/archive/0.9.1.tar.gz"
  sha256 "2b5b442d572b5978ea51c650adfaf0796f39f326404d09b83d846e04f571876b"

  bottle do
    cellar :any_skip_relocation
    sha256 "d50bc210a23dfaaa55c6164392572a5fe21d51f588b53087adaa131fcf233db7" => :mojave
    sha256 "d50bc210a23dfaaa55c6164392572a5fe21d51f588b53087adaa131fcf233db7" => :high_sierra
    sha256 "2ef924d9e34791e3c94128602ad48ab8ad34f6542712ab9b73e79c4a80ba2443" => :sierra
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
