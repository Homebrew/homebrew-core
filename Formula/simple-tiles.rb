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
    sha256 "873d8f241263b0d5cc5e3d5b6cba535bdb953c8311703aae2e95406301ec5d10" => :big_sur
    sha256 "14669b22f33782b72b0b2c8a0b37cbcbfe741d3923939eafe3546430d97e7683" => :arm64_big_sur
    sha256 "8543798355cbb329814f4214639ff750690f496d75c3986c1756de28c2a6aace" => :catalina
    sha256 "b2954855d7afd914fbac0bd06ed55b457c3d807285c24eb98f9641d88f7fa5ab" => :mojave
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
