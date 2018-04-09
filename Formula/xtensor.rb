class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.15.8.tar.gz"
  sha256 "4b226164a3ee347531be9ca3cbdda4b37afc8c0f5fc9c344eeaf3893889c7a03"

  bottle do
    cellar :any_skip_relocation
    sha256 "907d53c2becacff2d3cb5e8b8488ec0552254a005d4d6538ccd1592b08a6c6b4" => :high_sierra
    sha256 "907d53c2becacff2d3cb5e8b8488ec0552254a005d4d6538ccd1592b08a6c6b4" => :sierra
    sha256 "907d53c2becacff2d3cb5e8b8488ec0552254a005d4d6538ccd1592b08a6c6b4" => :el_capitan
  end

  needs :cxx14
  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/QuantStack/xtl/archive/0.4.5.tar.gz"
    sha256 "cfd531884e500c1cd01c86ed707f1c097658f6180a3a08708266e8c9f349f222"
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
