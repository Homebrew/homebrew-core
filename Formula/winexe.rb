class Winexe < Formula
  desc "Remote Windows-command executor"
  homepage "https://sourceforge.net/projects/winexe/"
  url "https://downloads.sourceforge.net/project/winexe/winexe-1.00.tar.gz"
  sha256 "99238bd3e1c0637041c737c86a05bd73a9375abc9794dca71d2765e22d87537e"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, catalina:    "4706b05f203ecaf3a56fc453d3c6588fd151d9ce4b8be0f6973725f70379dad3"
    sha256 cellar: :any_skip_relocation, mojave:      "43444e53e90a4f739a533e4a865952369874d9386460205e501631fa2b3ad2bb"
    sha256 cellar: :any_skip_relocation, high_sierra: "765ad670de08f86b8c9b11ec43493148d1368e6c3ffa5e65d1bca898480996c2"
    sha256 cellar: :any_skip_relocation, sierra:      "e9594f927f9ef58608951175c0bd118b82cf7b25d5b829453195b66f45c2cbc1"
    sha256 cellar: :any_skip_relocation, el_capitan:  "58080b3729c9b261a65c7db2072ec867176bfd6a802c23f9b343feb44592789a"
  end

  # Original deprecation date: 2022-07-26
  disable! date: "2022-11-03", because: "depends on Python 2 to build"

  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "perl"

  # This Winexe uses "getopts.pl" that is no longer supplied with newer
  # versions of Perl
  resource "Perl4::CoreLibs" do
    url "https://cpan.metacpan.org/authors/id/Z/ZE/ZEFRAM/Perl4-CoreLibs-0.003.tar.gz"
    sha256 "55c9b2b032944406dbaa2fd97aa3692a1ebce558effc457b4e800dabfaad9ade"
  end

  # This patch removes second definition of event context, which *should* break the build
  # virtually everywhere, but for some reason it only breaks it on macOS.
  # https://miskstuf.tumblr.com/post/6840077505/winexe-1-00-linux-macos-windows-7-finally-working
  # Added by @vspy
  patch :DATA

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resource("Perl4::CoreLibs").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    cd "source4" do
      system "./autogen.sh"
      system "./configure", "--enable-fhs"
      system "make", "basics", "idl", "bin/winexe"
      bin.install "bin/winexe"
    end
  end

  test do
    system "#{bin}/winexe", "--version"
  end
end

__END__
diff -Naur winexe-1.00-orig/source4/winexe/winexe.h winexe-1.00/source4/winexe/winexe.h
--- winexe-1.00-orig/source4/winexe/winexe.h    2011-06-18 00:00:00.000000000 +0000
+++ winexe-1.00/source4/winexe/winexe.h 2011-06-18 00:00:00.000000000 +0000
@@ -63,7 +63,7 @@
 int async_write(struct async_context *c, const void *buf, int len);
 int async_close(struct async_context *c);

-struct tevent_context *ev_ctx;
+extern struct tevent_context *ev_ctx;

 /* winexesvc32_exe.c */
 extern unsigned int winexesvc32_exe_len;
