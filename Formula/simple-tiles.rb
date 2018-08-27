class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://propublica.github.io/simple-tiles/"
  url "https://github.com/propublica/simple-tiles/archive/v0.6.1.tar.gz"
  sha256 "2391b2f727855de28adfea9fc95d8c7cbaca63c5b86c7286990d8cbbcd640d6f"
  revision 2
  head "https://github.com/propublica/simple-tiles.git"

  bottle do
    cellar :any
    sha256 "25fa849815c7f5f5ea98c36e61a6a967d43377c163e78f6731c06de5f98e73d6" => :mojave
    sha256 "5032c76efb7ae602dcafda7a048110ea123662b06835a077d329558c58fdddc8" => :high_sierra
    sha256 "30efcc0e5fcb844511c341015f251fb81226e434d16b0c5451fc7381da2a841a" => :sierra
    sha256 "101c3442589eb596e46e5df2a64f69bbb6d12909ef4fa0d0d4f86607258b3194" => :el_capitan
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
           "-I#{Formula["pango"].opt_include}/pango-1.0",
           "test.c", "-o", "test"
    system testpath/"test"
  end
end
