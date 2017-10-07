class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.12.1.tar.gz"
  sha256 "f2df34fa30a99bb9e65d4f9dffd5194b6e6cfb523f01e2cc17a1c2ccbd995d27"

  bottle do
    cellar :any_skip_relocation
    sha256 "adbbca7731e978bc4b95b79570e394eeb03440873678a874bf6a5471865d9128" => :high_sierra
    sha256 "adbbca7731e978bc4b95b79570e394eeb03440873678a874bf6a5471865d9128" => :sierra
    sha256 "adbbca7731e978bc4b95b79570e394eeb03440873678a874bf6a5471865d9128" => :el_capitan
  end

  needs :cxx14
  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/QuantStack/xtl/archive/0.2.8.tar.gz"
    sha256 "05e9def47023215d4f595c24ba412df665b1f1856937d80f2cade770cb9a0b44"
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
    (testpath/"test.cc").write <<-EOS.undent
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
