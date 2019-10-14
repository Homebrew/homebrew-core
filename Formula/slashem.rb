require "etc"

class Slashem < Formula
  desc "Fork/variant of Nethack"
  homepage "https://slashem.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/slashem/slashem-source/0.0.8E0F1/se008e0f1.tar.gz"
  version "0.0.8E0F1"
  sha256 "e9bd3672c866acc5a0d75e245c190c689956319f192cb5d23ea924dd77e426c3"

  bottle do
    cellar :any_skip_relocation
    sha256 "96fc5b1abd0e8deff9573c43656e7f3caa25b51d28eb8f426cec7c28131ab4b0" => :catalina
    sha256 "7a764f6117556d92fad752ec06dc28626c0e250632eac85cfa8d841f7c770819" => :mojave
    sha256 "5bac56b4e76ea1db5b5e211ac88c4f10c2fa8b179ada29512f41868af1669b3d" => :high_sierra
    sha256 "80a4df38057ec2bef889b92b4edfc80158add542a1bd9f1ca50ed8d39eb21e2c" => :sierra
    sha256 "3b0ec09db5b1e2abccc22d2cc9282de211d9a15e4d2d66c404f898af2768d1b3" => :el_capitan
    sha256 "9220e4e678c8302cd7c1ae15b4af08a733899c38717021c867e35decf79f00a7" => :yosemite
  end

  depends_on "pkg-config" => :build

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
