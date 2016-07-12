class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://propublica.github.io/simple-tiles/"
  url "https://github.com/propublica/simple-tiles/archive/v0.6.0.tar.gz"
  sha256 "336fdc04c34b85270c377d880a0d4cc2ac1a9c9e5e4c3d53e0322d43c9495ac9"
  revision 4

  head "https://github.com/propublica/simple-tiles.git"

  bottle do
    cellar :any
    sha256 "2149c71e36591d45633bcf6b328644429e5e62d2a7a3b585e0249597629a74c0" => :el_capitan
    sha256 "c4c5859f7f96c4c76d1cf79b8c9e1654e80a9a5cd1d25084d551e6ecdfe6d41c" => :yosemite
    sha256 "bdbb2dd2a81061f8590782877ef1a4c55001774f0339893292eb7f73dbe1e7a9" => :mavericks
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
    (testpath/"test.c").write <<-EOS.undent
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
