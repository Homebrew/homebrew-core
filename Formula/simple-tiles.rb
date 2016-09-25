class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://propublica.github.io/simple-tiles/"
  url "https://github.com/propublica/simple-tiles/archive/v0.6.0.tar.gz"
  sha256 "336fdc04c34b85270c377d880a0d4cc2ac1a9c9e5e4c3d53e0322d43c9495ac9"
  revision 5

  head "https://github.com/propublica/simple-tiles.git"

  bottle do
    cellar :any
    sha256 "1e5649e397cd57b78c12fd06bad43568c1484be76ea5d819e9b8e6df081e1001" => :sierra
    sha256 "a9bf8e3de3044aecab01110d5d919c15c64d0fff89c26cc3ff879ffa1a837286" => :el_capitan
    sha256 "20fafe97446ab8a4fe137e28b24a1d664888e36258f6b2ed4b18d1f47a35bb4d" => :yosemite
    sha256 "790dd1f5bb2e7e5fff0fcdeb8216c5dea2c0ce73ad46d0bfb770c4c0501707eb" => :mavericks
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
