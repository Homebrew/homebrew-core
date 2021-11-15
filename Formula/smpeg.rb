class Smpeg < Formula
  desc "SDL MPEG Player Library"
  homepage "https://icculus.org/smpeg/"
  url "svn://svn.icculus.org/smpeg/tags/release_0_4_5/", revision: "399"

  livecheck do
    url "https://svn.icculus.org/smpeg/tags/"
    regex(%r{href=.*?release[._-]v?([01](?:[._]\d+)+)/}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "119f4031fd0ada3466a78b55310b6f05facee84d9c9a01b71f3f17d8f2b613f3"
    sha256 cellar: :any,                 arm64_big_sur:  "1078558dafa6125c781a6b50242fc8def024f36dc3d8f4c1ae719c05779f12c2"
    sha256 cellar: :any,                 monterey:       "4b07d003520cc8ac1a9422efc9630cb7f316b75ed9b1f4195cb88c3f1c5a095f"
    sha256 cellar: :any,                 big_sur:        "1b667d8cc8548a25b1a5c16e706f9fba9a0a4a3380c1674ba64444abb3d18837"
    sha256 cellar: :any,                 catalina:       "929cb2fe89f7525acbf38a269bde8aaf07f7b2d406007ee9df2d21051a0ccba6"
    sha256 cellar: :any,                 mojave:         "6e826bd49ceb171cc36877c0498d8ccfc3c614f39b684728e0c307b69942d58c"
    sha256 cellar: :any,                 high_sierra:    "2779c8aba2aed376076e53fc9e2e694e8b5fabca0096ae91eed786b73ef3704f"
    sha256 cellar: :any,                 sierra:         "9ac1a1c83a9861b8762ab711d709e67bf020204fb1c1b5907b244d83ced4ab2c"
    sha256 cellar: :any,                 el_capitan:     "a4bf36f39959150e1f0cd83c8f58761ce59acdee50f591a1f695665b7517728a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b5a86bc35fd6f8e17cf6445fd8d9aa7246ac77e75e3d4d6e7c1c3d66154fa35"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl"

  # Fix -flat_namespace being used on Big Sur and later.
  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --with-sdl-prefix=#{Formula["sdl"].opt_prefix}
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
