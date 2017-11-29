class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.14.0.tar.gz"
  sha256 "c0d33bcd878352eaa4a2aa91f1e8c0d980bf2cd10089c822cb33737a843402d9"

  bottle do
    cellar :any_skip_relocation
    sha256 "4dcbfbd75f166c48150e3de5067a4437cb2be859f238b2b23798b02f0ef7c2a5" => :high_sierra
    sha256 "4dcbfbd75f166c48150e3de5067a4437cb2be859f238b2b23798b02f0ef7c2a5" => :sierra
    sha256 "4dcbfbd75f166c48150e3de5067a4437cb2be859f238b2b23798b02f0ef7c2a5" => :el_capitan
  end

  needs :cxx14
  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/QuantStack/xtl/archive/0.3.6.tar.gz"
    sha256 "37f5ba13d4e73d9ff74d9a01d72ec0a58ad237933ae2ccdba0746dbe325aadc3"
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
