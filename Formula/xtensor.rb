class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.18.3.tar.gz"
  sha256 "c736123cc1bf55e2afbd3edc65f28ef726fc56f90fb525240789ff089f805932"

  bottle do
    cellar :any_skip_relocation
    sha256 "b46dd3646001667b70cfda56669b79319e98285452275b72b8a2c6997d8b7af4" => :mojave
    sha256 "511082568320b43c89b5ce43cd3c6f2fde2a68c50363911e237b5ba0a6eea6f5" => :high_sierra
    sha256 "511082568320b43c89b5ce43cd3c6f2fde2a68c50363911e237b5ba0a6eea6f5" => :sierra
  end

  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/QuantStack/xtl/archive/0.4.16.tar.gz"
    sha256 "480b1b9afd810838f8635beea9056f0591a0b4fd4181abaf32c698dfd01bf0ea"
  end

  needs :cxx14

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
