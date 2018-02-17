class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.15.4.tar.gz"
  sha256 "1383d34d79c4c579d577a502b145b458f74e1d76749d31a893beec5c6799098c"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b6e1c0609438526f38b941d787b2e447c4999a84a6fc0f1490c024c4c8a0441" => :high_sierra
    sha256 "7b6e1c0609438526f38b941d787b2e447c4999a84a6fc0f1490c024c4c8a0441" => :sierra
    sha256 "7b6e1c0609438526f38b941d787b2e447c4999a84a6fc0f1490c024c4c8a0441" => :el_capitan
  end

  needs :cxx14
  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/QuantStack/xtl/archive/0.4.0.tar.gz"
    sha256 "2cfe9acbcc4e484f3aa33a98892a09ffe79bb9c0dfd3ffc57b3561f44c591e7c"
  end

  def install
    resource("xtl").stage do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end

    system "cmake", ".", "-Dxtl_DIR=#{lib}/cmake/xtl", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include "xtensor/xarray.hpp"
      #include "xtensor/xio.hpp"

      int main() {
        xt::xarray<double> arr1
          {{11.0, 12.0, 13.0},
           {21.0, 22.0, 23.0},
           {31.0, 32.0, 33.0}};

        xt::xarray<double> arr2
          {100.0, 200.0, 300.0};

        xt::xarray<double> res = xt::view(arr1, 1) + arr2;

        std::cout << res(2) << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cc", "-o", "test", "-I#{include}"
    assert_equal "323", shell_output("./test").chomp
  end
end
