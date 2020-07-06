class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://propublica.github.io/simple-tiles/"
  url "https://github.com/propublica/simple-tiles/archive/v0.6.1.tar.gz"
  sha256 "2391b2f727855de28adfea9fc95d8c7cbaca63c5b86c7286990d8cbbcd640d6f"
  license "MIT"
  revision 8
  head "https://github.com/propublica/simple-tiles.git"

  bottle do
    cellar :any
    sha256 "4189c71a64c384fe516f1db1f20f9cd275e435f7b88995c21ce412ba272620f5" => :catalina
    sha256 "80cf79f642357f6c408d0081020eca4638e13def659b2eb5f8a84cb3bf4e6392" => :mojave
    sha256 "f737a155c3021b2c33655ce3f70f8d11d178197e8ce2d5669e73fede374c0d1b" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gdal"
  depends_on "pango"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <simple-tiles/simple_tiles.h>

      int main(){
        simplet_map_t *map = simplet_map_new();
        simplet_map_free(map);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lsimple-tiles",
           "-I#{Formula["cairo"].opt_include}/cairo",
           "-I#{Formula["gdal"].opt_include}",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           "-I#{Formula["harfbuzz"].opt_include}/harfbuzz",
           "-I#{Formula["pango"].opt_include}/pango-1.0",
           "test.c", "-o", "test"
    system testpath/"test"
  end
end
