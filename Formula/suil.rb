class Suil < Formula
  desc "Lightweight C library for loading and wrapping LV2 plugin UIs"
  homepage "https://drobilla.net/software/suil/"
  url "https://download.drobilla.net/suil-0.10.0.tar.bz2"
  sha256 "9895c531f80c7e89a2b4b47de589d73b70bf48db0b0cfe56e5d54237ea4b8848"

  bottle do
    sha256 "3afa0d6be51f6edd803fa1d295a5b1816e2ea36a53c0921174360231b41dfe95" => :high_sierra
    sha256 "a31a360a2eb861408d9b7df5abee8f1368b83899bacb0ac065e37dd9290b8220" => :sierra
    sha256 "ebd26a4d8d4d7ff3531ea93c3da499b333dd42b8ffa0b3ad70d79976a5c5fbe9" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "lv2"
  depends_on "gtk+" => :recommended
  depends_on :x11 => :optional

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
