class Suil < Formula
  desc "Lightweight C library for loading and wrapping LV2 plugin UIs"
  homepage "https://drobilla.net/software/suil/"
  url "https://download.drobilla.net/suil-0.10.0.tar.bz2"
  sha256 "9895c531f80c7e89a2b4b47de589d73b70bf48db0b0cfe56e5d54237ea4b8848"
  revision 1

  bottle do
    rebuild 1
    sha256 "5923dafda40c49d3ee3a402e497d642433111bfc041a286798bc952b46940079" => :mojave
    sha256 "c8271567bd28cab7dfaacb5dc60c4031b3ec32b36e54604cb8ef2db16074d624" => :high_sierra
    sha256 "75da682959d5f8a3ea4abbf6fd7da223c3c48a6e196629ecc1fe76e619c500ae" => :sierra
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
