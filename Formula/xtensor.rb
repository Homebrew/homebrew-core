class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "https://xtensor.readthedocs.io/en/latest/"
  url "https://github.com/QuantStack/xtensor/archive/0.23.4.tar.gz"
  sha256 "c8377f8ec995762c89dea2fdf4ac06b53ba491a6f0df3421c4719355e42425d2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0f9254d829d62028528ce92a8653d288f243af018be14f4eaf07996699a947aa"
    sha256 cellar: :any_skip_relocation, big_sur:       "b81d51e8d6b2f99efbdb89b0d1f492cba687469c821ba1bd8dd7e0b954ce6b92"
    sha256 cellar: :any_skip_relocation, catalina:      "2c6a3e6874ea41ab79d381ee7dd223e7f482bd78bf11c7d18d9b2cdad5a08b2a"
    sha256 cellar: :any_skip_relocation, mojave:        "b877077d4b4a9d5c57a8b26b30eb8c2a2b0486c9c7c4aadacc60ac92eebf4df8"
  end

  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/xtensor-stack/xtl/archive/0.7.2.tar.gz"
    sha256 "95c221bdc6eaba592878090916383e5b9390a076828552256693d5d97f78357c"
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
