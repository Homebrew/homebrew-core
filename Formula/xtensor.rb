class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.11.0.tar.gz"
  sha256 "1e4826f78e9181160b1cb36d0004c0297978b067f7b081c559490745ce3daa66"

  bottle do
    cellar :any_skip_relocation
    sha256 "8455a76570122329bda5753c4ceeaa70c970414b7bbae0a42d2335ac4cbcefac" => :sierra
    sha256 "8455a76570122329bda5753c4ceeaa70c970414b7bbae0a42d2335ac4cbcefac" => :el_capitan
    sha256 "8455a76570122329bda5753c4ceeaa70c970414b7bbae0a42d2335ac4cbcefac" => :yosemite
  end

  needs :cxx14
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
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
