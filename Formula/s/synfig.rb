class Synfig < Formula
  desc "Command-line renderer"
  homepage "https://synfig.org/"
  license "GPL-3.0-or-later"
  revision 6

  stable do
    url "https://downloads.sourceforge.net/project/synfig/development/1.5.1/synfig-1.5.1.tar.gz"
    mirror "https://github.com/synfig/synfig/releases/download/v1.5.1/synfig-1.5.1.tar.gz"
    sha256 "aa91593c28a89f269be1be9c8bd9ecca6491f9e6af26744d1c160c6553ee2ced"

    # Apply upstream commit to fix build with ffmpeg:
    # https://github.com/synfig/synfig/commit/f684b24f0db31ab8ea7aadc417fc23e3084b4138
    # Removew with next release.
    patch :DATA
  end

  livecheck do
    url :stable
    regex(%r{url=.*?/synfig[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "9a207a4d04477200a97b293a121ee23bef93b79fa7d35753d2434cd2ba3f8755"
    sha256 arm64_ventura:  "b7783b968173a20f5cb238d5d6b96aec8bab90c028b06e4d0e83175260aad337"
    sha256 arm64_monterey: "d12edc24c209c6c1b69b4c33bea61f69928e8b754ed9bfe8e135d33ab598f475"
    sha256 sonoma:         "bb0a61eb27adc040065977fd59f493b4d6f17f8ca36424a5093f957b1819c953"
    sha256 ventura:        "5cab6f62912a985f4f5d3032e5dea7835c9b369b02b8d5d2a0283c3168d7dd98"
    sha256 monterey:       "dcda0015cf9409f91c8796c04daf6dc012ac29672a36b4c5e9afa5073d68d431"
  end

  head do
    url "https://github.com/synfig/synfig.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "cairo"
  depends_on "etl"
  depends_on "ffmpeg@6"
  depends_on "fftw"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "imagemagick"
  depends_on "libpng"
  depends_on "libsigc++@2"
  depends_on "libtool"
  depends_on "libxml++"
  depends_on "mlt"
  depends_on "openexr"
  depends_on "pango"

  uses_from_macos "perl" => :build

  fails_with gcc: "5"

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?
    ENV.cxx11

    if build.head?
      cd "synfig-core"
      system "./bootstrap.sh"
    end
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
                          "--without-jpeg"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <stddef.h>
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
    glibmm = Formula["glibmm@2.66"]
    libpng = Formula["libpng"]
    libsigcxx = Formula["libsigc++@2"]
    libxmlxx = Formula["libxml++"]
    mlt = Formula["mlt"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{cairo.opt_include}/cairo
      -I#{etl.opt_include}/ETL
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
      -I#{mlt.opt_include}/mlt-7
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
      -lmlt-7
      -lmlt++-7
      -lpango-1.0
      -lpangocairo-1.0
      -lpthread
      -lsigc-2.0
      -lsynfig
      -lxml++-2.6
      -lxml2
    ]
    flags << "-lintl" if OS.mac?
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end

__END__
diff --git a/src/modules/mod_libavcodec/trgt_av.cpp b/src/modules/mod_libavcodec/trgt_av.cpp
index 6baccb4..bea55cc 100644
--- a/src/modules/mod_libavcodec/trgt_av.cpp
+++ b/src/modules/mod_libavcodec/trgt_av.cpp
@@ -38,6 +38,7 @@
 extern "C"
 {
 #ifdef HAVE_LIBAVFORMAT_AVFORMAT_H
+#   include <libavcodec/avcodec.h>
 #	include <libavformat/avformat.h>
 #elif defined(HAVE_AVFORMAT_H)
 #	include <avformat.h>
@@ -232,12 +233,14 @@ public:
 		close();

 		if (!av_registered) {
+#if LIBAVCODEC_VERSION_MAJOR < 59 // FFMPEG < 5.0
 			av_register_all();
+#endif
 			av_registered = true;
 		}

 		// guess format
-		AVOutputFormat *format = av_guess_format(NULL, filename.c_str(), NULL);
+		const AVOutputFormat *format = av_guess_format(NULL, filename.c_str(), NULL);
 		if (!format) {
 			synfig::warning("Target_LibAVCodec: unable to guess the output format, defaulting to MPEG");
 			format = av_guess_format("mpeg", NULL, NULL);
@@ -252,6 +255,7 @@ public:
 		context = avformat_alloc_context();
 		assert(context);
 		context->oformat = format;
+#if LIBAVCODEC_VERSION_MAJOR < 59 // FFMPEG < 5.0
 		if (filename.size() + 1 > sizeof(context->filename)) {
 			synfig::error(
 				"Target_LibAVCodec: filename too long, max length is %d, filename is '%s'",
@@ -261,6 +265,14 @@ public:
 			return false;
 		}
 		memcpy(context->filename, filename.c_str(), filename.size() + 1);
+#else
+ 		context->url = av_strndup(filename.c_str(), filename.size());
+ 		if (!context->url) {
+ 			synfig::error("Target_LibAVCodec: cannot allocate space for filename");
+ 			close();
+ 			return false;
+ 		}
+#endif

 		packet = av_packet_alloc();
 		assert(packet);
