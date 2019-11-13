class Sratom < Formula
  desc "Library for serializing LV2 atoms to/from RDF"
  homepage "https://drobilla.net/software/sratom/"
  url "https://download.drobilla.net/sratom-0.6.4.tar.bz2"
  sha256 "146c8f14b8902ac3c8fa8c2e0a014eb8a38fab60090c5adbfbff3e3b7c5c006e"

  bottle do
    cellar :any
    sha256 "ec520015be09bdd89bd9081aac42426dbe66fd935a5cc8a71fd9bf64cc971a71" => :mojave
    sha256 "1db4ed5d8d3dd5f85406e8394da49ecab4d8ecca7fafd8e02fb87c76b0e24d3f" => :high_sierra
    sha256 "cb62fd202ce3c33cda2529bc957681ffa70037e99d54df8a81999e890b9fcb65" => :sierra
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
