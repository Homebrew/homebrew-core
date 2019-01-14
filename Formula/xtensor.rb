class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.19.1.tar.gz"
  sha256 "52ac9081138d413485b9bf70376722f109ab32e5ed2ed3311257f5d7e9a88bc7"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc74f983037ca4a758d78dbde45f15c23a23bef89121445e9d34e333da0ba85d" => :mojave
    sha256 "12699f58693e800205659da72af462965efb3d305823df255b23d9b7e01bc7fb" => :high_sierra
    sha256 "12699f58693e800205659da72af462965efb3d305823df255b23d9b7e01bc7fb" => :sierra
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
