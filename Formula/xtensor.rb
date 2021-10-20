class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "https://xtensor.readthedocs.io/en/latest/"
  url "https://github.com/QuantStack/xtensor/archive/0.24.0.tar.gz"
  sha256 "37738aa0865350b39f048e638735c05d78b5331073b6329693e8b8f0902df713"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "747274fb86b2a0bcd4e12a07b37fe73a3fd5b5079f51278b67cef20e31687862"
  end

  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/xtensor-stack/xtl/archive/0.7.2.tar.gz"
    sha256 "95c221bdc6eaba592878090916383e5b9390a076828552256693d5d97f78357c"
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
