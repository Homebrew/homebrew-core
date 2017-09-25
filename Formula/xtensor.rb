class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.11.3.tar.gz"
  sha256 "22900f7e331967db75e474382994d8b89139065a321581ade3cb26fbbc2b3c9d"

  bottle do
    cellar :any_skip_relocation
    sha256 "033d0469d9261636b3276209e8660ac4957cf1715e72b6d79b0141955e0e89dc" => :high_sierra
    sha256 "033d0469d9261636b3276209e8660ac4957cf1715e72b6d79b0141955e0e89dc" => :sierra
    sha256 "033d0469d9261636b3276209e8660ac4957cf1715e72b6d79b0141955e0e89dc" => :el_capitan
  end

  needs :cxx14
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<-EOS.undent
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
