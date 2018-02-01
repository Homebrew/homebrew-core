class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.15.1.tar.gz"
  sha256 "2f4ac632f7aa8c8e9da99ebbfc949d9129b4d644f715ef16c27658bf4fddcdd3"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7f52cf829a5ad740fc80250d4a3b92ad783fc0949ddb1c919a86c5e540fa070" => :high_sierra
    sha256 "b7f52cf829a5ad740fc80250d4a3b92ad783fc0949ddb1c919a86c5e540fa070" => :sierra
    sha256 "b7f52cf829a5ad740fc80250d4a3b92ad783fc0949ddb1c919a86c5e540fa070" => :el_capitan
  end

  needs :cxx14
  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/QuantStack/xtl/archive/0.4.0.tar.gz"
    sha256 "2cfe9acbcc4e484f3aa33a98892a09ffe79bb9c0dfd3ffc57b3561f44c591e7c"
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
