class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "https://xtensor.readthedocs.io/en/latest/"
  url "https://github.com/xtensor-stack/xtensor/archive/refs/tags/0.27.2.tar.gz"
  sha256 "4421d2f710c5817bc8864f952edb5ffdd8202c31681c4f26b49a0e4197ac6d70"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e9e663ab72cc432d95d61cb76e2c062ca1d86a40fe1120cdb92cd22a4623928b"
  end

  depends_on "cmake" => :build
  depends_on "xtl"

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <iostream>
      #include "xtensor/containers/xarray.hpp"
      #include "xtensor/io/xio.hpp"
      #include "xtensor/views/xview.hpp"

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
    CPP

    system ENV.cxx, "-std=c++20", "test.cc", "-o", "test", "-I#{include}"
    assert_equal "323", shell_output("./test").chomp
  end
end
