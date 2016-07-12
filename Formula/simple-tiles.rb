class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://propublica.github.io/simple-tiles/"
  url "https://github.com/propublica/simple-tiles/archive/v0.6.0.tar.gz"
  sha256 "336fdc04c34b85270c377d880a0d4cc2ac1a9c9e5e4c3d53e0322d43c9495ac9"
  revision 4

  head "https://github.com/propublica/simple-tiles.git"

  bottle do
    cellar :any
    sha256 "6ba9433632bb61877b12a0e10e14fa5367808954848c6351ca189237c957d02d" => :el_capitan
    sha256 "701c8f13570a2df44acb68949de1003a187d5f21dc2c6ab4681a0812621727ee" => :yosemite
    sha256 "54c230c2d7cfd35c7e78cb469b174b0721c313866bb99ca1ef2defcb5d0b3cf3" => :mavericks
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
