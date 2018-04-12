class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "http://quantstack.net/xtensor"
  url "https://github.com/QuantStack/xtensor/archive/0.15.9.tar.gz"
  sha256 "2a2386f526c3c5fdfeda43515c68e503ff237e55cdb5c6f43db0161e2ee19a56"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ef3d29de9e94bc3bd05ac758aac255d00d6ec220a66a9391d4ba1851e66866f" => :high_sierra
    sha256 "7ef3d29de9e94bc3bd05ac758aac255d00d6ec220a66a9391d4ba1851e66866f" => :sierra
    sha256 "7ef3d29de9e94bc3bd05ac758aac255d00d6ec220a66a9391d4ba1851e66866f" => :el_capitan
  end

  needs :cxx14
  depends_on "cmake" => :build

  resource "xtl" do
    url "https://github.com/QuantStack/xtl/archive/0.4.6.tar.gz"
    sha256 "eef96ae4519e5e268a5d15a5ecf16ebcd9268310314794a009bf64a804105302"
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
