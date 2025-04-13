class VorbisTools < Formula
  desc "Ogg Vorbis CODEC tools"
  homepage "https://github.com/xiph/vorbis-tools"
  url "https://ftp.osuosl.org/pub/xiph/releases/vorbis/vorbis-tools-1.4.2.tar.gz"
  mirror "https://mirror.csclub.uwaterloo.ca/xiph/releases/vorbis/vorbis-tools-1.4.2.tar.gz"
  sha256 "db7774ec2bf2c939b139452183669be84fda5774d6400fc57fde37f77624f0b0"
  license all_of: [
    "LGPL-2.0-or-later", # intl/ (libintl)
    "GPL-2.0-or-later", # share/
    "GPL-2.0-only", # oggenc/, vorbiscomment/
  ]
  revision 2

  livecheck do
    url "https://ftp.osuosl.org/pub/xiph/releases/vorbis/?C=M&O=D"
    regex(%r{href=(?:["']?|.*?/)vorbis-tools[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "343a4e371842b02770f028c3d99da8e7ccd69d4355236e325f8cc5bce821f624"
    sha256 cellar: :any,                 arm64_sonoma:  "60fb0e8aa8c078b0da5dbb0dfe85a3c4c5c1839250747f295b06a4e207f8b76b"
    sha256 cellar: :any,                 arm64_ventura: "fec9739002fb209a076dee4dadd61d3d33821dada8b0fd3bd626dea4b6c97434"
    sha256 cellar: :any,                 sonoma:        "5d78e28782150b8c4cc7513b247f5a3581b9e43e7d44bd96506653c9d4836e4a"
    sha256 cellar: :any,                 ventura:       "1c2ba768164d520ec340d8e64123def553d68ae9a1e5a563de0189002de51fb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47b64b5fe010a3a16f8b59e84f8e484ea58655ae6ad675cda687a253cecc7dc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "adbea8feac0228f61088ab0fbe5c5280794f00dcc5cb28daf7e7b80ec8f7176a"
  end

  depends_on "pkgconf" => :build
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
    if OS.mac? && (MacOS.version >= :monterey)
      # Workaround for Xcode 14 ld.
      system "autoreconf", "--force", "--install", "--verbose"
    end

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", *std_configure_args, "--disable-nls", "--without-speex"
    system "make", "install"
  end

  test do
    system bin/"oggenc", test_fixtures("test.wav"), "-o", "test.ogg"
    assert_path_exists testpath/"test.ogg"
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
 
