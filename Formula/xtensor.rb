class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.16.2.tar.gz"
  sha256 "411c8d62194e3f90f318a5455ed7f5af8f9f27a54dae502aa07186f5d971f4e9"

  bottle do
    cellar :any_skip_relocation
    sha256 "685fc0620858fa9fd75d1460a76f4c5d0f3538d2604eb3f62afa94faeb6e60e7" => :high_sierra
    sha256 "685fc0620858fa9fd75d1460a76f4c5d0f3538d2604eb3f62afa94faeb6e60e7" => :sierra
    sha256 "685fc0620858fa9fd75d1460a76f4c5d0f3538d2604eb3f62afa94faeb6e60e7" => :el_capitan
  end

  needs :cxx14
  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/QuantStack/xtl/archive/0.4.9.tar.gz"
    sha256 "587251bb7787b7dd05a2d432712bb2a7f05411155c61a9bc4a0f69c7b4e85dc3"
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
      #include "xtensor/xview.hpp"

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
