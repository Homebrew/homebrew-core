class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.14.1.tar.gz"
  sha256 "cccfb4604ad428d89b0534bbd9e1a77a2a242e967627c2a3e819d8fe289ed835"

  bottle do
    cellar :any_skip_relocation
    sha256 "dfd4a7e8d7d6e432ec1f984b2beea402bc8ac568170f3ab9b6efbd87cc05c900" => :high_sierra
    sha256 "dfd4a7e8d7d6e432ec1f984b2beea402bc8ac568170f3ab9b6efbd87cc05c900" => :sierra
    sha256 "dfd4a7e8d7d6e432ec1f984b2beea402bc8ac568170f3ab9b6efbd87cc05c900" => :el_capitan
  end

  needs :cxx14
  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/QuantStack/xtl/archive/0.3.7.tar.gz"
    sha256 "8ae9611e70ba6bf4836c90776aaa11ab872b7938a7433fc5779fa2af724d8226"
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
