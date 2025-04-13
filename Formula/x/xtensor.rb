class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "https://xtensor.readthedocs.io/en/latest/"
  url "https://github.com/xtensor-stack/xtensor/archive/refs/tags/0.26.0.tar.gz"
  sha256 "f5f42267d850f781d71097b50567a480a82cd6875a5ec3e6238555e0ef987dc6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2348111bd2e2567d4f0a1d9958b625ec145dbfb6666989e164c99700bedbf12a"
  end

  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/xtensor-stack/xtl/archive/refs/tags/0.8.0.tar.gz"
    sha256 "ee38153b7dd0ec84cee3361f5488a4e7e6ddd26392612ac8821cbc76e740273a"
  end

  def install
    resource("xtl").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    system "cmake", "-S", ".", "-B", "build", "-Dxtl_DIR=#{lib}/cmake/xtl", *std_cmake_args
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

    system ENV.cxx, "-std=c++17", "test.cc", "-o", "test", "-I#{include}"
    assert_equal "323", shell_output("./test").chomp
  end
end
