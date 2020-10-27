class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "https://xtensor.readthedocs.io/en/latest/"
  url "https://github.com/QuantStack/xtensor/archive/0.21.8.tar.gz"
  sha256 "1330743aa1554178a97bfeeefe80b2ace47492c93086a813346e80b8d0426e12"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "8a449477609f50a23e7e82ca032173eb5ab0be0ad70686e8d654d1b945cba697" => :catalina
    sha256 "d6d7b6e202aa84f8340fa8313d6ca416b3bc01427fdad1227555b3e669437617" => :mojave
    sha256 "76e3337a06e3ebab77221535a8c8e279b8d77cbc982d5f3cf86686ea3cf33936" => :high_sierra
  end

  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/xtensor-stack/xtl/archive/0.6.20.tar.gz"
    sha256 "fe25d8ae90e2598221f4dd330cfa390efbf256b48ab72a00bc2290b45f3a59cc"
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
