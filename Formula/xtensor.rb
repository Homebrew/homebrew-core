class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.19.0.tar.gz"
  sha256 "afb3e32175baae010a0a09580f6692cce096119b1ffc519d7aaa2b64a9dd7602"

  bottle do
    cellar :any_skip_relocation
    sha256 "69f990ca04c43227f4106ab0c05357cae57b528ca0f492e637886191d132dc7b" => :mojave
    sha256 "421f15eda0fddfdf10c9fc762f7553353b1b40588b2d8514870d3f5c66a1fe89" => :high_sierra
    sha256 "421f15eda0fddfdf10c9fc762f7553353b1b40588b2d8514870d3f5c66a1fe89" => :sierra
  end

  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/QuantStack/xtl/archive/0.5.2.tar.gz"
    sha256 "6f9d2f849e4dd8a36db1e62648ed1855a691991739119b0a73cd55084c6d28b2"
  end

  needs :cxx14

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
