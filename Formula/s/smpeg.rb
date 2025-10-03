class Smpeg < Formula
  desc "SDL MPEG Player Library"
  homepage "https://icculus.org/smpeg/"
  url "https://github.com/icculus/smpeg/archive/refs/tags/release_0_4_5.tar.gz"
  sha256 "e2e53bfd2e6401e2c29e5eb3929be0e8698bc9e4c9d731751f67e77b408f1f74"
  # license change was done in 2021 Aug, which is 8 years after 0.4.5 release
  # commit ref, https://github.com/icculus/smpeg/commit/ffa0d54
  license "LGPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^release[._-]v?([01](?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "8b74893276266d73531cf99e6cb182bf238868d2d06c8a0051262ae15dd8a574"
    sha256 cellar: :any,                 arm64_sequoia:  "e7a1451326b54dd9107b43762c877fc91a8d9cb7fcae37aad8f4a354c98c56bf"
    sha256 cellar: :any,                 arm64_sonoma:   "d489427a87ed930d4d72e1536180d1781eb4f1f68992e5a2934c71df0dfbd7ed"
    sha256 cellar: :any,                 arm64_ventura:  "8023f2a680920c2c2184d38422b4111359ee56dad5a3fa5abcf66e06ebbc3242"
    sha256 cellar: :any,                 arm64_monterey: "f6bec866d75df98036cdf109c1f98fd0fa2be764e4f82a8d7382e4e5b4affa08"
    sha256 cellar: :any,                 arm64_big_sur:  "75662ff4a7c2f2c1202fddcc301872696aa5123718028541cff67db96acad8d2"
    sha256 cellar: :any,                 sonoma:         "457f91decc06341f70afa9a2812ac4398a3ed28f353bdb0d6616fd8dec8059d7"
    sha256 cellar: :any,                 ventura:        "03c1eb05860e58ea080834b7fc760a10dc28aec402fb684c9a263b716693ec8f"
    sha256 cellar: :any,                 monterey:       "27336fb6005e4d498db6eb1f68deee86cad53c86ac10843984f833e2bf5bcb7d"
    sha256 cellar: :any,                 big_sur:        "7c97d1fb7a8df3df8cca2eb794a7898d9dc4c93ae3f201dc582ed8982c74e725"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b4b46134434032d24f664aac17650a6641c70f589fce7dda983fb5b78a2db25b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b98076e9055fbe29549fd5c340deb22c733c24f3ab754a638dd24c425ba076d3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "sdl12-compat"

  # Fix -flat_namespace being used on Big Sur and later.
  patch :DATA

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-c++11-narrowing" if DevelopmentTools.clang_build_version >= 1400

    args = %W[
      --with-sdl-prefix=#{Formula["sdl12-compat"].opt_prefix}
      --disable-gtk-player
      --disable-gtktest
      --disable-opengl-player
      --disable-sdltest
    ]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./autogen.sh"
    system "./configure", *args, *std_configure_args
    system "make"
    # Install script is not +x by default for some reason
    chmod 0755, "./install-sh"
    system "make", "install"

    # Not present since we do not build with gtk+
    rm(man1/"gtv.1")
  end

  test do
    system bin/"plaympeg", "--version"
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
