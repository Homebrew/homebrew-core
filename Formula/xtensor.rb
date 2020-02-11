class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "https://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.21.3.tar.gz"
  sha256 "f63c25cafea4bfc268edb26e6f5004a28a2f689e6a852bb3559c553106c8d6bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "2848fed25528ce4da3c70b9ff8eaf69a219a8f1220f77a8bbf1eb16a70c920a9" => :catalina
    sha256 "2848fed25528ce4da3c70b9ff8eaf69a219a8f1220f77a8bbf1eb16a70c920a9" => :mojave
    sha256 "2848fed25528ce4da3c70b9ff8eaf69a219a8f1220f77a8bbf1eb16a70c920a9" => :high_sierra
  end

  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/QuantStack/xtl/archive/0.6.11.tar.gz"
    sha256 "e3cb622def174b76547c29ce0d63ae1407ed19fcbbd233913613e9859568eadd"
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
