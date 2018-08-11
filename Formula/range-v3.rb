class RangeV3 < Formula
  desc "Experimental range library for C++11/14/17"
  homepage "https://ericniebler.github.io/range-v3/"
  url "https://github.com/ericniebler/range-v3/archive/0.3.6.tar.gz"
  sha256 "ce6e80c6b018ca0e03df8c54a34e1fd04282ac1b068cd39e902e2e5201ac117f"

  bottle do
    cellar :any_skip_relocation
    sha256 "9bf428673c29823dd64d70ace970439b9d5e83bf4ffed0116e3c2ff86aaca445" => :el_capitan_or_later
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
