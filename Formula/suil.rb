class Suil < Formula
  desc "Lightweight C library for loading and wrapping LV2 plugin UIs"
  homepage "https://drobilla.net/software/suil/"
  url "https://download.drobilla.net/suil-0.10.6.tar.bz2"
  sha256 "06fc70abaa33bd7089dd1051af46f89d378e8465d170347a3190132e6f009b7c"

  bottle do
    sha256 "d47dfcab557ae99bf0d1fe6950f43a4fc83babbff35430beba7234fc78c9ad7e" => :catalina
    sha256 "5edd9d88d7fbac6909430c73ffdcdf1ea3bc8ed7ccad2ffe5e132a256fb92a3b" => :mojave
    sha256 "7cd481bd8924581cb61e3fcfd9fd6811d898c6b2dc18aae80007dc75e11a7671" => :high_sierra
    sha256 "22ad8a4f9858b90574bd1f1e9028d37a37003a4e5b211baa3a2f400dedc65e38" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "lv2"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <suil/suil.h>

      int main()
      {
        return suil_ui_supported("my-host", "my-ui");
      }
    EOS
    lv2 = Formula["lv2"].opt_include
    system ENV.cc, "-I#{lv2}", "-I#{include}/suil-0", "-L#{lib}", "-lsuil-0", "test.c", "-o", "test"
    system "./test"
  end
end
