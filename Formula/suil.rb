class Suil < Formula
  desc "Lightweight C library for loading and wrapping LV2 plugin UIs"
  homepage "https://drobilla.net/software/suil/"
  url "https://download.drobilla.net/suil-0.10.6.tar.bz2"
  sha256 "06fc70abaa33bd7089dd1051af46f89d378e8465d170347a3190132e6f009b7c"

  bottle do
    sha256 "588d837f629e7850d05a28f561852bd990229623748baf8c13be9337dc5d8e2a" => :catalina
    sha256 "1497f4ef4de7dc80b8f79913ecc46203ddd3dc1f0afa117fed6ba4c3f448a4d9" => :mojave
    sha256 "811369571b4c28268a130c040b8019ebf77fa26b4410022891b45d7ad2c03eb3" => :high_sierra
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
