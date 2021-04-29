class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "https://xtensor.readthedocs.io/en/latest/"
  url "https://github.com/QuantStack/xtensor/archive/0.23.8.tar.gz"
  sha256 "bddb3e03a6fc7d39463df25e1b1a72aac79db7f0f32813c5d34feb7c2708b6b5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "66edb59835a248e3ea1ecdee5c687b26381d1d8ecb2254384deefcbba67ffe87"
    sha256 cellar: :any_skip_relocation, big_sur:       "49931220607cfdd81feea226d1a7afa5fac4726ce35503354780721b474e5c58"
    sha256 cellar: :any_skip_relocation, catalina:      "49931220607cfdd81feea226d1a7afa5fac4726ce35503354780721b474e5c58"
    sha256 cellar: :any_skip_relocation, mojave:        "aac8d8b3bef91ac7ec6dab8a7045ef7448006975143158f566ee8577f407f756"
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
