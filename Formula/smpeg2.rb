class Smpeg2 < Formula
  desc "SDL MPEG Player Library"
  homepage "https://icculus.org/smpeg/"
  url "svn://svn.icculus.org/smpeg/tags/release_2_0_0/", revision: "408"
  head "svn://svn.icculus.org/smpeg/trunk"

  livecheck do
    url "https://svn.icculus.org/smpeg/tags/"
    regex(%r{href=.*?release[._-]v?(2(?:[._]\d+)+)/}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a3dff365e85c05609fdb62d1d72f9d376308f437aad9bbb19823e9b4aa02bb61"
    sha256 cellar: :any,                 arm64_big_sur:  "bf514f604adc800528192749aff14cf262f959b0c398174cb045fdea206b06ba"
    sha256 cellar: :any,                 monterey:       "5633c4f20cfefc11012b516c62f4152fafed42771db861b48977d49c0a8da356"
    sha256 cellar: :any,                 big_sur:        "816b0441d6d10986dea2c3b55f7889a9a72783c2fc55e92520fe9366b53a769c"
    sha256 cellar: :any,                 catalina:       "97d4ca204752184752822f6c4bbbff2e044d110917f6a0ce30c3c472d6cb622c"
    sha256 cellar: :any,                 mojave:         "4ecef89d7ee22d5d23703a5ac29fb6b4fc0cd025e249219a194ca325d79dfa85"
    sha256 cellar: :any,                 high_sierra:    "927cb1d5dd58481afd16e893868a0794b42d56588e7fe9d51b881812e2f26eb6"
    sha256 cellar: :any,                 sierra:         "05ea6a84c6ff07c3c88e89f0ecd153c5cd92866d3edb8cc4b4dfd06f445971b7"
    sha256 cellar: :any,                 el_capitan:     "52aba7403eee04f66c9184a741354b747dfcd0994fa3bd7de9058b65a30fcf19"
    sha256 cellar: :any,                 yosemite:       "6031bf704fd0508bb90322dbe77f62580708e3fe77362e3dea6b0691360b686b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4f7a11825ee5ba5b2f538f0309de8eae59607bc9019a3d2168a6a35f9fb79a7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"

  # Fix -flat_namespace being used on Big Sur and later.
  # We patch `libtool.m4` because we need to generate the `configure` script.
  patch :DATA

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--with-sdl-prefix=#{Formula["sdl2"].opt_prefix}",
                          "--disable-dependency-tracking",
                          "--disable-debug",
                          "--disable-sdltest"
    system "make"
    system "make", "install"

    # To avoid a possible conflict with smpeg 0.x
    mv "#{bin}/plaympeg", "#{bin}/plaympeg2"
    mv "#{man1}/plaympeg.1", "#{man1}/plaympeg2.1"
  end

  test do
    system "#{bin}/plaympeg2", "--version"
  end
end

__END__
diff --git a/acinclude/libtool.m4 b/acinclude/libtool.m4
index 7dfd109..f8b1ac0 100644
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
