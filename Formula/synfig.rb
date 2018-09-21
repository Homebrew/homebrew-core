class Synfig < Formula
  desc "Command-line renderer"
  homepage "https://synfig.org/"
  url "https://downloads.sourceforge.net/project/synfig/releases/1.0.2/source/synfig-1.0.2.tar.gz"
  sha256 "34cdf9eac90aadea29fb2997e82da1c32713ab02940f7c8873330f894e167fb4"
  revision 5
  head "http://svn.code.sf.net/p/synfig/code/"

  bottle do
    sha256 "7051446f2836f7de2f71508639cd7e82de5b71013e55801124f6e5ecf426cca4" => :mojave
    sha256 "2f05123f7d5b6cd2d2e0ae7ba1bb070e5bf5bd69f71a85553ea45858ea18b7ab" => :high_sierra
    sha256 "ef83f8b014f601eeed4e7810d5edd5c41838ef0cf7df918674aa8975a670bcb7" => :sierra
    sha256 "42f7ab274f30645bd06e707a9e7962cabf7ba8766728c781e066efa2cd1a53ac" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "etl"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "libpng"
  depends_on "libsigc++"
  depends_on "libtool"
  depends_on "libxml++"
  depends_on "mlt"
  depends_on "openexr"
  depends_on "pango"

  # bug filed upstream as https://synfig.org/issues/thebuggenie/synfig/issues/904
  patch do
    url "https://gist.githubusercontent.com/tschoonj/06d5de3cdc5d063f8612/raw/26fe46b6eedeecdc686b9fd5aac01de9f2756424/synfig.diff"
    sha256 "0ac5b757ba3dda6a863a79e717fc239648c490eac1e643ff275b8ac232a466a3"
  end

  needs :cxx11

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
    libsigcxx = Formula["libsigc++"]
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
