class Suil < Formula
  desc "Lightweight C library for loading and wrapping LV2 plugin UIs"
  homepage "https://drobilla.net/software/suil/"
  url "https://download.drobilla.net/suil-0.10.4.tar.bz2"
  sha256 "a1e9899012790eef8867b5475853d76689b246cca88a99ac0d379a6c0d85c72b"

  bottle do
    sha256 "944c05e6ea4310151bc71ba51a5dc6348935bdf8f32c0207a7f0ff72228dc8ac" => :mojave
    sha256 "e6a553d61128f83423ee8fa0148591374896361458a770070124296bc3a233d0" => :high_sierra
    sha256 "598d8ef20cb58feaae68ab3aff70d0fa36492245961f0997cb408aa52937428a" => :sierra
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
