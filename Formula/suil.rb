class Suil < Formula
  desc "Lightweight C library for loading and wrapping LV2 plugin UIs"
  homepage "https://drobilla.net/software/suil/"
  url "https://download.drobilla.net/suil-0.10.4.tar.bz2"
  sha256 "a1e9899012790eef8867b5475853d76689b246cca88a99ac0d379a6c0d85c72b"

  bottle do
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
