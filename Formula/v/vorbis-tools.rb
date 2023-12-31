class VorbisTools < Formula
  desc "Ogg Vorbis CODEC tools"
  homepage "https://github.com/xiph/vorbis-tools"
  url "https://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.2.tar.gz", using: :homebrew_curl
  mirror "https://ftp.osuosl.org/pub/xiph/releases/vorbis/vorbis-tools-1.4.2.tar.gz"
  sha256 "db7774ec2bf2c939b139452183669be84fda5774d6400fc57fde37f77624f0b0"
  license all_of: [
    "LGPL-2.0-or-later", # intl/ (libintl)
    "GPL-2.0-or-later", # share/
    "GPL-2.0-only", # oggenc/, vorbiscomment/
  ]
  revision 1

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/vorbis/?C=M&O=D"
    regex(/href=.*?vorbis-tools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "489cbfd6edf230c8b989d3d8850b40a7d955d6081689a8553cf481930e892bc3"
    sha256 cellar: :any,                 arm64_ventura:  "fe8d1f90aa3e1c38f87be9e4593dbe8131282b4ed77effccd4c5e075c8af1330"
    sha256 cellar: :any,                 arm64_monterey: "81cc875b622067697081eaa3a72c2b36882d8fd3bef460563a124ae1fc6e3b99"
    sha256 cellar: :any,                 arm64_big_sur:  "02ea853ec06df9531f696865b196fc91fbca1360d7ab563859dfe37289cb7f9c"
    sha256 cellar: :any,                 sonoma:         "90a083123079cf3be3b6b3a73dfb35ef30e9537977c4ca8ae910a7973bd2f2bb"
    sha256 cellar: :any,                 ventura:        "eb58d309267de842f0c2cef39c535143038d262f8bad12c0c0a8a3a62c81d941"
    sha256 cellar: :any,                 monterey:       "b342fad37a61d9c407199ea27e78b10f9335a340488d6afdf3e76a70ab46981d"
    sha256 cellar: :any,                 big_sur:        "5557f52038523ac9030787fc23c2597bccdc56e64fecbca062a2cb6e0ff7597c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5bf7cdf6990819e485ad13b82e4206b9b9d53864533b2015361893e1611c494"
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libao"
  depends_on "libogg"
  depends_on "libvorbis"

  uses_from_macos "curl"

  on_monterey :or_newer do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    # Fix mistaken recursive `.a` files.
    patch :DATA
  end

  def install
    if OS.mac?
      # Prevent linkage with Homebrew Curl on macOS because of `using: :homebrew_curl` above.
      ENV.remove "HOMEBREW_DEPENDENCIES", "curl"
      ENV.remove "HOMEBREW_INCLUDE_PATHS", Formula["curl"].opt_include
      ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["curl"].opt_lib

      # Workaround for Xcode 14 ld.
      system "autoreconf", "--force", "--install", "--verbose" if MacOS.version >= :monterey
    end

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", *std_configure_args, "--disable-nls"
    system "make", "install"
  end

  test do
    system bin/"oggenc", test_fixtures("test.wav"), "-o", "test.ogg"
    assert_predicate testpath/"test.ogg", :exist?
    output = shell_output("#{bin}/ogginfo test.ogg")
    assert_match "20.625000 kb/s", output
  end
end

__END__
diff --git a/share/Makefile.am b/share/Makefile.am
index 1011f1d..bd69a67 100644
--- a/share/Makefile.am
+++ b/share/Makefile.am
@@ -11,7 +11,7 @@ libgetopt_a_SOURCES = getopt.c getopt1.c
 libbase64_a_SOURCES = base64.c
 
 libpicture_a_SOURCES = picture.c
-libpicture_a_LIBADD = libbase64.a
+libpicture_a_LIBADD = base64.o
 
 EXTRA_DIST = charmaps.h makemap.c charset_test.c charsetmap.h
 
