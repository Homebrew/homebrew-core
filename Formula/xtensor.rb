class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.13.0.tar.gz"
  sha256 "b4cdc733ecb834148eff03ddd9de96b99b2779ed3a8631c1d5e7fae4c84833f4"

  bottle do
    cellar :any_skip_relocation
    sha256 "107bbc1e0a34a4277906d1d50c98e92de4b7f16b7374bb2ef4afb0861561c831" => :high_sierra
    sha256 "107bbc1e0a34a4277906d1d50c98e92de4b7f16b7374bb2ef4afb0861561c831" => :sierra
    sha256 "107bbc1e0a34a4277906d1d50c98e92de4b7f16b7374bb2ef4afb0861561c831" => :el_capitan
  end

  needs :cxx14
  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/QuantStack/xtl/archive/0.3.3.tar.gz"
    sha256 "1110364c2ea0a2536ec6673e46afcb8fa7e92a66593211270bbeb26b85342600"
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
