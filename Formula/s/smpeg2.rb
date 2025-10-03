class Smpeg2 < Formula
  desc "SDL MPEG Player Library"
  homepage "https://icculus.org/smpeg/"
  # license change was done in 2021 Aug, which is 8 years after 2.0.0 release
  # commit ref, https://github.com/icculus/smpeg/commit/ffa0d54
  url "https://github.com/icculus/smpeg/archive/refs/tags/release_2_0_0.tar.gz"
  sha256 "fdd431bd607efcf0f35789fb3105d7535d4f0e8b46e673e9c0051726e8d1e701"
  license "LGPL-2.0-or-later"
  head "https://github.com/icculus/smpeg.git", branch: "main"

  livecheck do
    url :stable
    regex(/^release[._-]v?(2(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "f577393854025f6e32304032a00a3f29a27af3e71a52502025315f86b44ae9fb"
    sha256 cellar: :any,                 arm64_sequoia:  "dbbac559473f137fb4f16051e47fdab335581c72076ddab6535a9fba87c21749"
    sha256 cellar: :any,                 arm64_sonoma:   "d5228a92c9648cecb15aedbf8620e684f5b6b21d55b5e577f0c0564865211e46"
    sha256 cellar: :any,                 arm64_ventura:  "1287239a0f8877f88abba30316694f2e453be55143ab33748e850ea35ccdacce"
    sha256 cellar: :any,                 arm64_monterey: "f37c33bf42b5cbb9b849e4f2eba7484a3197a003d72d65e06ce663d803ed4ec2"
    sha256 cellar: :any,                 arm64_big_sur:  "57d207a4e472f427f2aed7052e14988b67cd1d310ae49070b77913f49a3f984f"
    sha256 cellar: :any,                 sonoma:         "8bd2271e2cea9d9f2ea56130e77612a9dcdc248f881d6cc548e9f09cfc640413"
    sha256 cellar: :any,                 ventura:        "94333f1da48b4cf080d29f3c87bd51df3c637d657f41d83eec7aa92ff4f503ee"
    sha256 cellar: :any,                 monterey:       "5d90c31b398b3d1bdf2ebcc1a10b4879804733f8335dc4a77998d38f8e976b79"
    sha256 cellar: :any,                 big_sur:        "4bec13f2819af5a5f3472481df37b7c6afdaa884fce40023057484936caad58c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "21fa4f02887307bf5eb069733e06cb3931cad92ffefd27a8d2ebd49d6b9afb23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57ef23a33dcadc1871ad7e12fe7dfddaa7e6773704691af46616b03f8c9f83b7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "sdl2"

  # Fix -flat_namespace being used on Big Sur and later.
  # We patch `libtool.m4` because we need to generate the `configure` script.
  patch :DATA

  def install
    args = ["--with-sdl-prefix=#{Formula["sdl2"].opt_prefix}", "--disable-sdltest"]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./autogen.sh"
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"

    # To avoid a possible conflict with smpeg 0.x
    mv bin/"plaympeg", bin/"plaympeg2"
    mv man1/"plaympeg.1", man1/"plaympeg2.1"
  end

  test do
    system bin/"plaympeg2", "--version"
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
diff --git a/audio/hufftable.cpp b/audio/hufftable.cpp
index 6bc8e86..1ef2d7e 100644
--- a/audio/hufftable.cpp
+++ b/audio/hufftable.cpp
@@ -550,11 +550,11 @@ htd33[ 31][2]={{ 16,  1},{  8,  1},{  4,  1},{  2,  1},{  0,  0},{  0,  1},

 const HUFFMANCODETABLE MPEGaudio::ht[HTN]=
 {
-  { 0, 0-1, 0-1, 0,  0, htd33},
+  { 0, 0u-1, 0u-1, 0,  0, htd33},
   { 1, 2-1, 2-1, 0,  7,htd01},
   { 2, 3-1, 3-1, 0, 17,htd02},
   { 3, 3-1, 3-1, 0, 17,htd03},
-  { 4, 0-1, 0-1, 0,  0, htd33},
+  { 4, 0u-1, 0u-1, 0,  0, htd33},
   { 5, 4-1, 4-1, 0, 31,htd05},
   { 6, 4-1, 4-1, 0, 31,htd06},
   { 7, 6-1, 6-1, 0, 71,htd07},
@@ -564,7 +564,7 @@ const HUFFMANCODETABLE MPEGaudio::ht[HTN]=
   {11, 8-1, 8-1, 0,127,htd11},
   {12, 8-1, 8-1, 0,127,htd12},
   {13,16-1,16-1, 0,511,htd13},
-  {14, 0-1, 0-1, 0,  0, htd33},
+  {14, 0u-1, 0u-1, 0,  0, htd33},
   {15,16-1,16-1, 0,511,htd15},
   {16,16-1,16-1, 1,511,htd16},
   {17,16-1,16-1, 2,511,htd16},
