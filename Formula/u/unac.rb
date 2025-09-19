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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "5e3436d86661dae0bcfda2b5064f3978fb4d5a2573ce656dc146c762e42161e8"
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
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7bcb9bedf0de026241c6f1de1bcffe69c67c1cfdfd5c8e590ffb7a5d09ce8c40"
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
    ENV.append_path "ACLOCAL_PATH", Formula["gettext"].pkgshare/"m4"

    touch "config.rpath"
    inreplace "autogen.sh", "libtool", "glibtool"
    system "./autogen.sh"
    system "./configure", *std_configure_args

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
