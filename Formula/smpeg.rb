class Smpeg < Formula
  desc "SDL MPEG Player Library"
  homepage "https://icculus.org/smpeg/"
  url "svn://svn.icculus.org/smpeg/tags/release_0_4_5/", revision: "399"
  revision 1

  livecheck do
    url "https://svn.icculus.org/smpeg/tags/"
    regex(%r{href=.*?release[._-]v?([01](?:[._]\d+)+)/}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "504f24fcc195211810c6d0f810452051d3bedeeb8418948458dea50645ea0d56"
    sha256 cellar: :any,                 arm64_monterey: "c5eab6893599eb3853a814df8bd10232024992b610e464713faef09c9b89af15"
    sha256 cellar: :any,                 arm64_big_sur:  "a681c545d54533151554e7ae875ceb10ab50557265b6903e82a7db1f649195a0"
    sha256 cellar: :any,                 ventura:        "2897235fc45521bd90346d67627a7d1fc8a43bb4c6077e1eea0b861f7d3573f9"
    sha256 cellar: :any,                 monterey:       "0dee6e8e4fc6dc7b4d97813c61c3bd31613c158dc17f4cf9ae3c24f91d93b591"
    sha256 cellar: :any,                 big_sur:        "a095b94ab3d0072785c4e5c59ee5518b83e5d8d677f77561dbc5e53026313c32"
    sha256 cellar: :any,                 catalina:       "884228b0396550379ea0f63b23cba2a078d495470424096232b6eff869972a08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e66be23025650d303fb1d05e4203d5d696369052d5cdd5f5289c69b00f7405e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl12-compat"

  # Fix -flat_namespace being used on Big Sur and later.
  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --with-sdl-prefix=#{Formula["sdl12-compat"].opt_prefix}
      --disable-dependency-tracking
      --disable-debug
      --disable-gtk-player
      --disable-gtktest
      --disable-opengl-player
      --disable-sdltest
    ]

    system "./autogen.sh"
    system "./configure", *args
    system "make"
    # Install script is not +x by default for some reason
    chmod 0755, "./install-sh"
    system "make", "install"

    # Not present since we do not build with gtk+
    rm_f "#{man1}/gtv.1"
  end

  test do
    system "#{bin}/plaympeg", "--version"
  end
end

__END__
diff --git a/acinclude/libtool.m4 b/acinclude/libtool.m4
index 6894db8..1aea405 100644
--- a/acinclude/libtool.m4
+++ b/acinclude/libtool.m4
@@ -947,18 +947,13 @@ m4_defun_once([_LT_REQUIRED_DARWIN_CHECKS],[
       _lt_dar_allow_undefined='${wl}-undefined ${wl}suppress' ;;
     darwin1.*)
       _lt_dar_allow_undefined='${wl}-flat_namespace ${wl}-undefined ${wl}suppress' ;;
-    darwin*) # darwin 5.x on
-      # if running on 10.5 or later, the deployment target defaults
-      # to the OS version, if on x86, and 10.4, the deployment
-      # target defaults to 10.4. Don't you love it?
-      case ${MACOSX_DEPLOYMENT_TARGET-10.0},$host in
-	10.0,*86*-darwin8*|10.0,*-darwin[[91]]*)
-	  _lt_dar_allow_undefined='${wl}-undefined ${wl}dynamic_lookup' ;;
-	10.[[012]]*)
-	  _lt_dar_allow_undefined='${wl}-flat_namespace ${wl}-undefined ${wl}suppress' ;;
-	10.*)
-	  _lt_dar_allow_undefined='${wl}-undefined ${wl}dynamic_lookup' ;;
-      esac
+    darwin*)
+        case ${MACOSX_DEPLOYMENT_TARGET},$host in
+         10.[[012]],*|,*powerpc*)
+           _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
+         *)
+           _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
+        esac
     ;;
   esac
     if test "$lt_cv_apple_cc_single_mod" = "yes"; then
