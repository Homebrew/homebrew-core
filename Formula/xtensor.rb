class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.17.4.tar.gz"
  sha256 "45bb52d9ddcbea74ddd0b9f57cd6a733a6b52d8545c1164294e6dc70e9f64211"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae0e564b4b70f1eb787a7bf41c29811d27dd9da23b3117df8e153f4cffaa37a4" => :mojave
    sha256 "b118d3b17a1ae4c6fe8ca86a2be10f0eb5853e84017d32cb197b253e37e099d1" => :high_sierra
    sha256 "b118d3b17a1ae4c6fe8ca86a2be10f0eb5853e84017d32cb197b253e37e099d1" => :sierra
    sha256 "b118d3b17a1ae4c6fe8ca86a2be10f0eb5853e84017d32cb197b253e37e099d1" => :el_capitan
  end

  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/QuantStack/xtl/archive/0.4.16.tar.gz"
    sha256 "480b1b9afd810838f8635beea9056f0591a0b4fd4181abaf32c698dfd01bf0ea"
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
