class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "https://xtensor.readthedocs.io/en/latest/"
  url "https://github.com/QuantStack/xtensor/archive/0.21.7.tar.gz"
  sha256 "03c517c1614fcef667150f436b387626d00c65bdd11c55a5da36e29cf849bfc0"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "8568b35a4b75c51e28887a0f68e658e2a3257fda91070de601f2c2b77b576778" => :catalina
    sha256 "2c7baddc17bdd3e0521a0c2244498e7c8f2860bf5b00426615095d46cfa88278" => :mojave
    sha256 "869e75b04b0e9246b6e1a862af79b5c1ae2e2a1b1ad60c27150e292cf4754135" => :high_sierra
  end

  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/xtensor-stack/xtl/archive/0.6.18.tar.gz"
    sha256 "4999013881cc1e1c12941fb9c9ed4a701d09ba83c72b8abac3011793a3a6fee3"
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
