class Suil < Formula
  desc "Lightweight C library for loading and wrapping LV2 plugin UIs"
  homepage "https://drobilla.net/software/suil/"
  url "https://download.drobilla.net/suil-0.10.10.tar.bz2"
  sha256 "750f08e6b7dc941a5e694c484aab02f69af5aa90edcc9fb2ffb4fb45f1574bfb"
  license "ISC"

  livecheck do
    url "https://download.drobilla.net/"
    regex(/href=.*?suil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "77388b3a76d608319f011867cf66d6e212cc75b325654f892af85a952fdf39a0" => :big_sur
    sha256 "ae9df00545cf2e938ad3a580e92b96b18b29de83645ca5f77c4f1e92e22f4df1" => :arm64_big_sur
    sha256 "7ae30ca6e4c23a5f0a8b47eb1ddbf20ac6c06896cc181aaf53f344be72a11abe" => :catalina
    sha256 "f21210f03d28fdd33d48e16094011aa4e1e0aa6f474eedb36932b2b0e1eabd32" => :mojave
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
