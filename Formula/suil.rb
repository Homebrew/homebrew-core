class Suil < Formula
  desc "Lightweight C library for loading and wrapping LV2 plugin UIs"
  homepage "https://drobilla.net/software/suil/"
  url "https://download.drobilla.net/suil-0.10.0.tar.bz2"
  sha256 "9895c531f80c7e89a2b4b47de589d73b70bf48db0b0cfe56e5d54237ea4b8848"
  revision 1

  bottle do
    sha256 "9c4394af565bb5bceadf67d921c6ee9434b12ba3c7c053168422b926a61b3711" => :mojave
    sha256 "836f6d8ad66cca4de66cd78c45205829627ee370b5485c0ef878bc9473d24ba6" => :high_sierra
    sha256 "babe1c998fd93f29b86a767e01ad1518b95e74e17769b517c092ed4cbc0878bf" => :sierra
    sha256 "639934ea8fd85b8968cf33838be1f399b7479e844fef972d4fca0ba2ab8a4bf4" => :el_capitan
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
