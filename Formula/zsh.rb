class Zsh < Formula
  desc "UNIX shell (command interpreter)"
  homepage "https://www.zsh.org/"
  url "https://downloads.sourceforge.net/project/zsh/zsh/5.5.1/zsh-5.5.1.tar.xz"
  mirror "https://www.zsh.org/pub/zsh-5.5.1.tar.xz"
  sha256 "e1c38808fcbe0cc1344d55c9a758349f7ba1e317325b154621ac37eddac4aa80"

  bottle do
    sha256 "93030b98b6f56656fe02470549deaf8d3e2fbe688a99cdb58784d1f5cb98761b" => :mojave
    sha256 "5629f78ced1b1a592bfd13536d5e9f4c265e22cb825c40992c3eea6d71727c80" => :high_sierra
    sha256 "a78193d233d74739539a258be269c8e66460984de44def032c1856f1a20bdeff" => :sierra
    sha256 "306e6694538f7fff80f240a7d99156139a931f5fc8f13403a7b8c95fc588df09" => :el_capitan
  end

  head do
    url "https://git.code.sf.net/p/zsh/code.git"
    depends_on "autoconf" => :build
  end

  option "without-etcdir", "Disable the reading of Zsh rc files in /etc"
  option "with-unicode9", "Build with Unicode 9 character width support"

  deprecated_option "disable-etcdir" => "without-etcdir"

  depends_on "gdbm" => :optional
  depends_on "pcre" => :optional

  resource "htmldoc" do
    url "https://downloads.sourceforge.net/project/zsh/zsh-doc/5.5.1/zsh-5.5.1-doc.tar.xz"
    mirror "https://www.zsh.org/pub/zsh-5.5.1-doc.tar.xz"
    sha256 "41ce13a89a6bc7e709b6f110e54288d59f02ba2becd2646895d28188d4dd6283"
  end

  def install
    system "Util/preconfig" if build.head?

    args = %W[
      --prefix=#{prefix}
      --enable-fndir=#{pkgshare}/functions
      --enable-scriptdir=#{pkgshare}/scripts
      --enable-site-fndir=#{HOMEBREW_PREFIX}/share/zsh/site-functions
      --enable-site-scriptdir=#{HOMEBREW_PREFIX}/share/zsh/site-scripts
      --enable-runhelpdir=#{pkgshare}/help
      --enable-cap
      --enable-maildir-support
      --enable-multibyte
      --enable-zsh-secure-free
      --with-tcsetpgrp
    ]

    args << "--disable-gdbm" if build.without? "gdbm"
    args << "--enable-pcre" if build.with? "pcre"
    args << "--enable-unicode9" if build.with? "unicode9"

    if build.without? "etcdir"
      args << "--disable-etcdir"
    else
      args << "--enable-etcdir=/etc"
    end

    system "./configure", *args

    # Do not version installation directories.
    inreplace ["Makefile", "Src/Makefile"],
      "$(libdir)/$(tzsh)/$(VERSION)", "$(libdir)"

    if build.head?
      # disable target install.man, because the required yodl comes neither with macOS nor Homebrew
      # also disable install.runhelp and install.info because they would also fail or have no effect
      system "make", "install.bin", "install.modules", "install.fns"
    else
      system "make", "install"
      system "make", "install.info"

      resource("htmldoc").stage do
        (pkgshare/"htmldoc").install Dir["Doc/*.html"]
      end
    end
  end

  test do
    assert_equal "homebrew", shell_output("#{bin}/zsh -c 'echo homebrew'").chomp
    system bin/"zsh", "-c", "printf -v hello -- '%s'"
  end
end
