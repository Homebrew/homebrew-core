class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://propublica.github.io/simple-tiles/"
  url "https://github.com/propublica/simple-tiles/archive/v0.6.1.tar.gz"
  sha256 "2391b2f727855de28adfea9fc95d8c7cbaca63c5b86c7286990d8cbbcd640d6f"
  revision 6
  head "https://github.com/propublica/simple-tiles.git"

  bottle do
    cellar :any
    sha256 "01524befcfe63132db75c049716bd9263168314fbbf1a6a16c5b5a17630607b1" => :catalina
    sha256 "a11f30c0385bd2b4f9f4f385c7b83f8ab8bb0655b4df93039dc5aac032b42efc" => :mojave
    sha256 "98bfedb532839b94020ccfef187e00d7598bf9b97d204e169d5718e246d09fbe" => :high_sierra
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
