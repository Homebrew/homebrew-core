class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://github.com/propublica/simple-tiles"
  url "https://github.com/propublica/simple-tiles/archive/v0.6.1.tar.gz"
  sha256 "2391b2f727855de28adfea9fc95d8c7cbaca63c5b86c7286990d8cbbcd640d6f"
  license "MIT"
  revision 10
  head "https://github.com/propublica/simple-tiles.git"

  bottle do
    cellar :any
    sha256 "4cce6d8d42a396e231de41e20a5b0fae80d775619f552d3fe2b8f8a608bbf926" => :big_sur
    sha256 "cb42c9630b6156cd4b1478f5b6116eb5aad521f90c6a003e0d6d7cbdfa6605e2" => :arm64_big_sur
    sha256 "67877ff99089d483f2b3bb515d3e680fa926cf7de384e8a5bbfa6925fef92e4c" => :catalina
    sha256 "ccc6df1dbcb3f0385b599fc30624d8fecb16bd9164391b104d17633b5d78f3e1" => :mojave
    sha256 "a8197a9dbc2b26296c88f7ebad0ece48e128a1194ffb7053dcf93d1718786ff4" => :high_sierra
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
