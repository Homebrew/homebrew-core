class Synfig < Formula
  desc "Command-line renderer"
  homepage "https://synfig.org/"
  url "https://downloads.sourceforge.net/project/synfig/releases/1.2.2/source/synfig-1.2.2.tar.gz"
  sha256 "5f5f7b33483041165f9a63fe4d95eb815971c7444569e574206f6964e83cc2ef"
  revision 2
  head "https://svn.code.sf.net/p/synfig/code/"

  bottle do
    sha256 "272749e10c523b22a622c9274578260758746c02393463183af2d7073ec33680" => :mojave
    sha256 "67861e53e6149a25b1fc0aa3c576e33bb55de48a0f15fc74fa0f95be92ff94ad" => :high_sierra
    sha256 "397224ae5e322f167d9ba42e8b8ea21e86db4a7c9ec3a439d8093430a4c1c538" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "etl"
  depends_on "fftw"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "libpng"
  depends_on "libsigc++@2"
  depends_on "libtool"
  depends_on "libxml++"
  depends_on "mlt"
  depends_on "openexr"
  depends_on "pango"

  def install
    ENV.cxx11
    boost = Formula["boost"]
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{boost.opt_prefix}",
                          "--without-jpeg"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <synfig/version.h>
      int main(int argc, char *argv[])
      {
        const char *version = synfig::get_version();
        return 0;
      }
    EOS
    ENV.libxml2
    cairo = Formula["cairo"]
    etl = Formula["etl"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    glibmm = Formula["glibmm"]
    libpng = Formula["libpng"]
    libsigcxx = Formula["libsigc++@2"]
    libxmlxx = Formula["libxml++"]
    mlt = Formula["mlt"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{cairo.opt_include}/cairo
      -I#{etl.opt_include}
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/giomm-2.4
      -I#{glibmm.opt_include}/glibmm-2.4
      -I#{glibmm.opt_lib}/giomm-2.4/include
      -I#{glibmm.opt_lib}/glibmm-2.4/include
      -I#{include}/synfig-1.0
      -I#{libpng.opt_include}/libpng16
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{libxmlxx.opt_include}/libxml++-2.6
      -I#{libxmlxx.opt_lib}/libxml++-2.6/include
      -I#{mlt.opt_include}
      -I#{mlt.opt_include}/mlt
      -I#{mlt.opt_include}/mlt++
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{cairo.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{libxmlxx.opt_lib}
      -L#{lib}
      -L#{mlt.opt_lib}
      -L#{pango.opt_lib}
      -lcairo
      -lgio-2.0
      -lgiomm-2.4
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lintl
      -lmlt
      -lmlt++
      -lpango-1.0
      -lpangocairo-1.0
      -lpthread
      -lsigc-2.0
      -lsynfig
      -lxml++-2.6
      -lxml2
    ]
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
