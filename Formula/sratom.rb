class Sratom < Formula
  desc "Library for serializing LV2 atoms to/from RDF"
  homepage "https://drobilla.net/software/sratom/"
  url "https://download.drobilla.net/sratom-0.6.4.tar.bz2"
  sha256 "146c8f14b8902ac3c8fa8c2e0a014eb8a38fab60090c5adbfbff3e3b7c5c006e"

  bottle do
    cellar :any
    sha256 "cec8ea9efb598554185a2195c3a5be91abf9b4b09e4d9400c9709155d2963c2c" => :catalina
    sha256 "b25239c1f3dabe314ec5fa91879d2f691fc83d4b23ed176022310b8b10a37e2c" => :mojave
    sha256 "c699c13f94f2fae5b4df4e68ccfe674c218e15f80302c1cf661038f75030a26a" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <sratom/sratom.h>

      int main()
      {
        return 0;
      }
    EOS
    lv2 = Formula["lv2"].opt_include
    serd = Formula["serd"].opt_include
    sord = Formula["sord"].opt_include
    system ENV.cc, "-I#{lv2}", "-I#{serd}/serd-0", "-I#{sord}/sord-0", "-I#{include}/sratom-0",
                   "-L#{lib}", "-lsratom-0", "test.c", "-o", "test"
    system "./test"
  end
end
