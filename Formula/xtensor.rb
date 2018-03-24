class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.15.6.tar.gz"
  sha256 "5a059ec8a8d4d1c173d7c56aea46b33d59988571fa77abca07b0269f2e0e4d77"

  bottle do
    cellar :any_skip_relocation
    sha256 "f395cc899fe35e66f4064095da13588c17d74d75a8b32ec182f2f1e7e1e49c1a" => :high_sierra
    sha256 "f395cc899fe35e66f4064095da13588c17d74d75a8b32ec182f2f1e7e1e49c1a" => :sierra
    sha256 "f395cc899fe35e66f4064095da13588c17d74d75a8b32ec182f2f1e7e1e49c1a" => :el_capitan
  end

  needs :cxx14
  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/QuantStack/xtl/archive/0.4.4.tar.gz"
    sha256 "2e24ae1e990b36c21134ee8b2017e4d8f1aa760ba0e62e57c9de8f6339052f7f"
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
