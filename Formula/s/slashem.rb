require "etc"

class Slashem < Formula
  desc "Fork/variant of Nethack"
  homepage "https://slashem.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/slashem/slashem-source/0.0.8E0F1/se008e0f1.tar.gz"
  version "0.0.8E0F1"
  sha256 "e9bd3672c866acc5a0d75e245c190c689956319f192cb5d23ea924dd77e426c3"
  license "NGPL"

  livecheck do
    url :stable
    regex(%r{url=.*?/slashem-source/([^/]+)/[^.]+\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "1f262c46f0f04c67c9996b01e8d89ea837d34c1086279ad1d480b63a11f74dd8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f3489647fb5f38f4016ef73e262df24407525bb01f076463c21f5b8340e47c27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cc225b937c53aa8a9121eb03ffcfd067a338a050df4b348cac6e8ea36c1cf19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbc49014eb4afffa42419df08cb98337389fb1d87b76c2c900553e0c3739f069"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07334e0d163f5aef7e77cd2047374806fccca1071f0e8e6057e3f740746cc139"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7fcb3b60e93f0119b791410997a9552c4dd409061eeb06d7b5461a4ab75a52b"
    sha256 cellar: :any_skip_relocation, sonoma:         "49cf816225af63b9cf625d938878571821849e7b1cd2ce28dd68ccaea9664e03"
    sha256 cellar: :any_skip_relocation, ventura:        "1094c0410fe6414fe94e7d583d31a483fa2cb5a432876da3d533b5beb853fc83"
    sha256 cellar: :any_skip_relocation, monterey:       "b7f005ad0ee38c512e4ec7f89c50ff88b86439b66d8c0fae05db62f933290ea8"
    sha256 cellar: :any_skip_relocation, big_sur:        "580468c6703c09d86a0904bb838e3bf8f98a1a21d7a694147b8bb61ea3428f88"
    sha256 cellar: :any_skip_relocation, catalina:       "96fc5b1abd0e8deff9573c43656e7f3caa25b51d28eb8f426cec7c28131ab4b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5e539a21570dc7e8141bdf68fcaf8dbce515fc6839e55e24a62a82b0362a8caa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03e6ce8d29f4ebd5eba336525f8d314b1f26c032d935389c704698f5881396f0"
  end

  depends_on "pkgconf" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  skip_clean "slashemdir/save"

  # Fixes compilation error in OS X: https://sourceforge.net/p/slashem/bugs/896/
  patch :DATA

  # https://sourceforge.net/p/slashem/bugs/964/ for C99 compatibility
  patch do
    url "https://sourceforge.net/p/slashem/bugs/964/attachment/slashem-c99.patch"
    sha256 "ef21a6e3c64a5cf5cfe83305df7611aa024384ae52ef6be4242b86d3d38da200"
  end

  # Fixes user check on older versions of OS X: https://sourceforge.net/p/slashem/bugs/895/
  # Fixed upstream: https://slashem.cvs.sourceforge.net/viewvc/slashem/slashem/configure?r1=1.13&r2=1.14&view=patch
  patch :p0 do
    url "https://gist.githubusercontent.com/mistydemeo/76dd291c77a509216418/raw/65a41804b7d7e1ae6ab6030bde88f7d969c955c3/slashem-configure.patch"
    sha256 "c91ac045f942d2ee1ac6af381f91327e03ee0650a547bbe913a3bf35fbd18665"
  end

  def install
    ENV.deparallelize
    # Fix issue where ioctl is not declared and fails on Sonoma
    inreplace "sys/share/ioctl.c", "#include \"hack.h\"", "#include \"hack.h\"\n#include <sys/ioctl.h>"

    args = %W[
      --with-mandir=#{man}
      --with-group=#{Etc.getpwuid.gid}
      --with-owner=#{Etc.getpwuid.name}
      --enable-wizmode=#{Etc.getpwuid.name}
    ]
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"

    man6.install "doc/slashem.6", "doc/recover.6"
  end

  test do
    cp_r "#{prefix}/slashemdir", testpath/"slashemdir"

    require "expect"
    require "pty"
    ENV["TERM"] = "xterm"
    PTY.spawn(prefix/"slashemdir/slashem", "-d", testpath/"slashemdir") do |r, w, pid|
      r.expect "Shall"
      w.write "q"
      Process.wait pid
    end
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
