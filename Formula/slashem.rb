require "etc"

class Slashem < Formula
  desc "Fork/variant of Nethack"
  homepage "https://slashem.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/slashem/slashem-source/0.0.8E0F1/se008e0f1.tar.gz"
  version "0.0.8E0F1"
  sha256 "e9bd3672c866acc5a0d75e245c190c689956319f192cb5d23ea924dd77e426c3"

  livecheck do
    url :stable
    regex(%r{url=.*?/slashem-source/([^/]+)/[^.]+\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbc49014eb4afffa42419df08cb98337389fb1d87b76c2c900553e0c3739f069"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07334e0d163f5aef7e77cd2047374806fccca1071f0e8e6057e3f740746cc139"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7fcb3b60e93f0119b791410997a9552c4dd409061eeb06d7b5461a4ab75a52b"
    sha256 cellar: :any_skip_relocation, ventura:        "1094c0410fe6414fe94e7d583d31a483fa2cb5a432876da3d533b5beb853fc83"
    sha256 cellar: :any_skip_relocation, monterey:       "b7f005ad0ee38c512e4ec7f89c50ff88b86439b66d8c0fae05db62f933290ea8"
    sha256 cellar: :any_skip_relocation, big_sur:        "580468c6703c09d86a0904bb838e3bf8f98a1a21d7a694147b8bb61ea3428f88"
    sha256 cellar: :any_skip_relocation, catalina:       "96fc5b1abd0e8deff9573c43656e7f3caa25b51d28eb8f426cec7c28131ab4b0"
    sha256 cellar: :any_skip_relocation, mojave:         "7a764f6117556d92fad752ec06dc28626c0e250632eac85cfa8d841f7c770819"
    sha256 cellar: :any_skip_relocation, high_sierra:    "5bac56b4e76ea1db5b5e211ac88c4f10c2fa8b179ada29512f41868af1669b3d"
    sha256 cellar: :any_skip_relocation, sierra:         "80a4df38057ec2bef889b92b4edfc80158add542a1bd9f1ca50ed8d39eb21e2c"
    sha256 cellar: :any_skip_relocation, el_capitan:     "3b0ec09db5b1e2abccc22d2cc9282de211d9a15e4d2d66c404f898af2768d1b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03e6ce8d29f4ebd5eba336525f8d314b1f26c032d935389c704698f5881396f0"
  end

  depends_on "pkg-config" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  skip_clean "slashemdir/save"

  # Fixes compilation error in OS X: https://sourceforge.net/p/slashem/bugs/896/
  patch :DATA

  # Fixes user check on older versions of OS X: https://sourceforge.net/p/slashem/bugs/895/
  # Fixed upstream: http://slashem.cvs.sourceforge.net/viewvc/slashem/slashem/configure?r1=1.13&r2=1.14&view=patch
  patch :p0 do
    url "https://gist.githubusercontent.com/mistydemeo/76dd291c77a509216418/raw/65a41804b7d7e1ae6ab6030bde88f7d969c955c3/slashem-configure.patch"
    sha256 "c91ac045f942d2ee1ac6af381f91327e03ee0650a547bbe913a3bf35fbd18665"
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-mandir=#{man}",
                          "--with-group=#{Etc.getpwuid.gid}",
                          "--with-owner=#{Etc.getpwuid.name}",
                          "--enable-wizmode=#{Etc.getpwuid.name}"
    system "make", "install"

    man6.install "doc/slashem.6", "doc/recover.6"
  end
end

__END__
diff --git a/win/tty/termcap.c b/win/tty/termcap.c
index c3bdf26..8d00b11 100644
--- a/win/tty/termcap.c
+++ b/win/tty/termcap.c
@@ -960,7 +960,7 @@ cl_eos()			/* free after Robert Viduya */

 #include <curses.h>

-#if !defined(LINUX) && !defined(__FreeBSD__)
+#if !defined(LINUX) && !defined(__FreeBSD__) && !defined(__APPLE__)
 extern char *tparm();
 #endif
