class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://propublica.github.io/simple-tiles/"
  url "https://github.com/propublica/simple-tiles/archive/v0.6.1.tar.gz"
  sha256 "2391b2f727855de28adfea9fc95d8c7cbaca63c5b86c7286990d8cbbcd640d6f"
  revision 4
  head "https://github.com/propublica/simple-tiles.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f4afdf9fc92f2e50bb9d9d688b13f0a498d67b33c96604d01d826f335450ac78" => :catalina
    sha256 "bb724cfcf8966cc53a5f0bf7905cd8703b1cb10e8bfa78401f8e294b38b9f40e" => :mojave
    sha256 "4ac4a9283ace0bf83b51c9edfd88c2d013ddb994cccc7fddc339dd6052c9f6d8" => :high_sierra
    sha256 "5459625985be9b05f9e77c1876b5cfc10b085dab3f9efaa2a142d822f2b6ecea" => :sierra
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
