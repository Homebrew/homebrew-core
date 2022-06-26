class Unac < Formula
  desc "C library and command that removes accents from a string"
  homepage "https://savannah.nongnu.org/projects/unac"
  url "https://deb.debian.org/debian/pool/main/u/unac/unac_1.8.0.orig.tar.gz"
  sha256 "29d316e5b74615d49237556929e95e0d68c4b77a0a0cfc346dc61cf0684b90bf"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4a72fdcbb521166b6e9e470cbbdd8027d52d883e849a3428583f5b00b16353fd"
    sha256 cellar: :any,                 arm64_big_sur:  "5d58477a342637a20d39e60b0164846f14e8f2aac2d1fc01e162e8eefef63af7"
    sha256 cellar: :any,                 monterey:       "9c0f897a477038083f9531c3a258f85df3dad6d5fbdcd0e00df8070ee4675c26"
    sha256 cellar: :any,                 big_sur:        "434a30fa5bd969126e166925e6509885bb45e12977f4690c08b2b4fbcfb20dd4"
    sha256 cellar: :any,                 catalina:       "c065103ee8b1c39a665dcca68787edadc6a60620e627912a721b3d5732ff0152"
    sha256 cellar: :any,                 mojave:         "29753f2d4ea3f9a56f9a3d8fdca4c4fe47044ff1bc986d9ecc06d5f376197da6"
    sha256 cellar: :any,                 high_sierra:    "eade4a2fba6e5828dccd3779b5e6681ca2558dbde421639624f089be835c55e8"
    sha256 cellar: :any,                 sierra:         "b97f2799eafd917f8fe1cc47c39634bc91a19ca452ce11ec8fd5edf37ea1dba3"
    sha256 cellar: :any,                 el_capitan:     "6c9d63dde182a55e237e63cfa4ab625164ce275e343fd88003483227bd7439bc"
    sha256 cellar: :any,                 yosemite:       "0db9b14eae2c3db5d2d268deb4a3369557a13d35dd216f4ea50aa0776eb56fb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee6f3909a8a3f44657dc39813bee9cd551475eb835973cb34be6cbd23fe7eb0f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "libtool" => :build

  on_macos do
    # configure.ac doesn't properly detect Mac OS's iconv library. This patch fixes that.
    patch :DATA
  end

  patch :p0 do
    url "https://bugs.debian.org/cgi-bin/bugreport.cgi?msg=5;filename=patch-libunac1.txt;att=1;bug=623340"
    sha256 "59e98d779424c17f6549860672085ffbd4dda8961d49eda289aa6835710b91c8"
  end

  patch :p0 do
    url "https://bugs.debian.org/cgi-bin/bugreport.cgi?msg=10;filename=patch-unaccent.c.txt;att=1;bug=623340"
    sha256 "a2fd06151214400ba007ecd2193b07bdfb81f84aa63323ef3e31a196e38afda7"
  end

  patch do
    url "https://deb.debian.org/debian/pool/main/u/unac/unac_1.8.0-6.diff.gz"
    sha256 "13a362f8d682670c71182ab5f0bbf3756295a99fae0d7deb9311e611a43b8111"
  end

  def install
    chmod 0755, "configure"
    touch "config.rpath"
    inreplace "autogen.sh", "libtool", "glibtool"
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # Separate steps to prevent race condition in folder creation
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    assert_equal "foo", shell_output("#{bin}/unaccent utf-8 fóó").strip
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 4a4eab6..9f25d50 100644
--- a/configure.ac
+++ b/configure.ac
@@ -49,6 +49,7 @@ AM_MAINTAINER_MODE

 AM_ICONV

+LIBS="$LIBS -liconv"
 AC_CHECK_FUNCS(iconv_open,,AC_MSG_ERROR([
 iconv_open not found try to install replacement from
 http://www.gnu.org/software/libiconv/
