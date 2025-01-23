class Unac < Formula
  desc "C library and command that removes accents from a string"
  homepage "https://savannah.nongnu.org/projects/unac"
  url "https://deb.debian.org/debian/pool/main/u/unac/unac_1.8.0.orig.tar.gz"
  sha256 "29d316e5b74615d49237556929e95e0d68c4b77a0a0cfc346dc61cf0684b90bf"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/u/unac/"
    regex(/href=.*?unac[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "648dfb172e5d6311dc6659235d05b5c22b814f48adab26a9a64288382f0a90d7"
    sha256 cellar: :any,                 arm64_sonoma:   "27170110668e4f920abf561c75cc4b8f0f9bed1ba84ab5b52426663f2fb68546"
    sha256 cellar: :any,                 arm64_ventura:  "9ef0e09918bdf4928f18a5ef4759da9877635890cae18a739b149d25933034f8"
    sha256 cellar: :any,                 arm64_monterey: "4a72fdcbb521166b6e9e470cbbdd8027d52d883e849a3428583f5b00b16353fd"
    sha256 cellar: :any,                 arm64_big_sur:  "5d58477a342637a20d39e60b0164846f14e8f2aac2d1fc01e162e8eefef63af7"
    sha256 cellar: :any,                 sonoma:         "98f6c4c1cdaef704abb8111989b7ab0bc8cf215164a6c8f175c1e6ef5b3ccda4"
    sha256 cellar: :any,                 ventura:        "46fa079329a7e44ea6f5d48cc8466d73cff663a9ceb2753159e0045babaff7f7"
    sha256 cellar: :any,                 monterey:       "9c0f897a477038083f9531c3a258f85df3dad6d5fbdcd0e00df8070ee4675c26"
    sha256 cellar: :any,                 big_sur:        "434a30fa5bd969126e166925e6509885bb45e12977f4690c08b2b4fbcfb20dd4"
    sha256 cellar: :any,                 catalina:       "c065103ee8b1c39a665dcca68787edadc6a60620e627912a721b3d5732ff0152"
    sha256 cellar: :any,                 mojave:         "29753f2d4ea3f9a56f9a3d8fdca4c4fe47044ff1bc986d9ecc06d5f376197da6"
    sha256 cellar: :any,                 high_sierra:    "eade4a2fba6e5828dccd3779b5e6681ca2558dbde421639624f089be835c55e8"
    sha256 cellar: :any,                 sierra:         "b97f2799eafd917f8fe1cc47c39634bc91a19ca452ce11ec8fd5edf37ea1dba3"
    sha256 cellar: :any,                 el_capitan:     "6c9d63dde182a55e237e63cfa4ab625164ce275e343fd88003483227bd7439bc"
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

  # Patches from https://udd.debian.org/patches.cgi?src=unac&version=1.8.0-8
  patch do
    url "https://sources.debian.org/data/main/u/unac/1.8.0-8/debian/patches/gcc-4-fix-bug-556379.patch"
    sha256 "f91d2c376826ff05eba7a13ee37b8152851f2c24ced29ee88afdf9b42b6a2fc8"
  end

  patch do
    url "https://sources.debian.org/data/main/u/unac/1.8.0-8/debian/patches/update-autotools.diff"
    sha256 "8310103e199edf477e3f3fd961a2ecb09bf361ba1602871b8a223b1ee65cc11a"
  end

  def install
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
