class RangeV3 < Formula
  desc "Experimental range library for C++11/14/17"
  homepage "https://ericniebler.github.io/range-v3/"
  url "https://github.com/ericniebler/range-v3/archive/0.3.6.tar.gz"
  sha256 "ce6e80c6b018ca0e03df8c54a34e1fd04282ac1b068cd39e902e2e5201ac117f"
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
      using std::cout;
      int main() {
        std::string s{ "hello" };
        ranges::for_each( s, [](char c){ cout << c << " "; });
        cout << "\n";
      }
    EOS
    system ENV.cc, "-std=c++11", "-o", "test", "test.cpp"
    system "./test"
  end
end
