class XtensorBlas < Formula
  desc "BLAS extension to xtensor"
  homepage "https://xtensor-blas.readthedocs.io/"
  url "https://github.com/QuantStack/xtensor-blas/archive/0.13.1.tar.gz"
  sha256 "3798fedc0def008662d2c99948b35ff01d6a86deffb6245b80fd37745c6c37d5"

  depends_on "cmake" => :build
  depends_on "xtensor"

  needs :cxx14

  def install
    args = std_cmake_args
    args << "-DCMAKE_PREFIX_PATH=#{prefix}"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include "xtensor/xarray.hpp"
      #include "xtensor/xview.hpp"
      #include "xtensor/xbuilder.hpp"
      #include "xtensor-blas/xblas.hpp"
      #include "xtensor-blas/xlinalg.hpp"
      int main() {
        xt::xarray<double> a = xt::arange(3 * 3);
        a.reshape({3, 3});
        xt::xarray<double> b = xt::arange(5 * 3);
        b.reshape({3, 5});

        auto ab = xt::linalg::dot(a, b);
        xt::xarray<double> ab_expected ={{ 25,  28,  31,  34,  37},
                                         { 70,  82,  94, 106, 118},
                                         {115, 136, 157, 178, 199}};
        if (ab_expected != ab) abort();
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cc", "-o", "test", "-I#{include}", "-lblas"
    system "./test"
  end
end
