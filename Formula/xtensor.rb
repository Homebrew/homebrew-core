class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.17.0.tar.gz"
  sha256 "8a9f028e0d36428ad2536b5d9bfb1b47b464d03b886cb42f56ce4936080a151a"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc113235fa1c774e30dfc781bfbc0aec45c9afa3e7fb535ca4b583555653d4d2" => :high_sierra
    sha256 "dc113235fa1c774e30dfc781bfbc0aec45c9afa3e7fb535ca4b583555653d4d2" => :sierra
    sha256 "dc113235fa1c774e30dfc781bfbc0aec45c9afa3e7fb535ca4b583555653d4d2" => :el_capitan
  end

  needs :cxx14
  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/QuantStack/xtl/archive/0.4.13.tar.gz"
    sha256 "60dd545ea9054d313437ec74cbbe62048803ec9f80086998200cf4fa9d31aabb"
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
