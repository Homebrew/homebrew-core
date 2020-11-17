class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "https://xtensor.readthedocs.io/en/latest/"
  url "https://github.com/QuantStack/xtensor/archive/0.21.10.tar.gz"
  sha256 "0d1ff8c5f801b566891cfb5c68718f838be94a0b6e07e3fc6164f66e5ec6d3b5"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "715f6aaffb3d3e83370442828c5ee006fb6f2785b3805bd432bc95c34a777b54" => :big_sur
    sha256 "eb3120f867fdc837cc5296f0451d47dcc0fb75f78736c2310964c5211dbcf75b" => :catalina
    sha256 "1b12d2e61e70d69d9468cee13552b0f12872cbc39b2fb8457569de070cdbfb73" => :mojave
    sha256 "78f897f2dab18c602020e2d1e342667abd0b153f6c9460a6ca90cd029d42f277" => :high_sierra
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
