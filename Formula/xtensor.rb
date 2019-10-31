class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "https://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.20.10.tar.gz"
  sha256 "91af282e7d029e27a4e981ac766a6b8d66a501bbe2e5ca0dc15e01af4f385af8"

  bottle do
    cellar :any_skip_relocation
    sha256 "215c1b54c488dbbcdba0072a925726a654b153598b37fbea17dd4266299cf222" => :catalina
    sha256 "215c1b54c488dbbcdba0072a925726a654b153598b37fbea17dd4266299cf222" => :mojave
    sha256 "215c1b54c488dbbcdba0072a925726a654b153598b37fbea17dd4266299cf222" => :high_sierra
  end

  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/QuantStack/xtl/archive/0.6.7.tar.gz"
    sha256 "89bb96be9a80e70eea1676e6ee7cee28d10ced77fa463b4502ec62ec4e951a61"
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
