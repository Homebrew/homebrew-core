class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://propublica.github.io/simple-tiles/"
  url "https://github.com/propublica/simple-tiles/archive/v0.6.1.tar.gz"
  sha256 "2391b2f727855de28adfea9fc95d8c7cbaca63c5b86c7286990d8cbbcd640d6f"
  head "https://github.com/propublica/simple-tiles.git"

  bottle do
    cellar :any
    sha256 "cbc2dea9c008f499c335bebb7bbb8c00fd19c797ae2442138175f794140e9396" => :high_sierra
    sha256 "2d3092fc48d4bc3fd7eb3679f09506bae62c6509756a55fbf6f9a3f18dd5e738" => :sierra
    sha256 "acbf4fd455b3351d3e5188361694cba78a98dec6f91ce70862e9a7a57b3d387b" => :el_capitan
    sha256 "42c5936f5beb15090b5199c1e97295ecf442c11ce52fe38876f2a992ffbcb160" => :yosemite
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
