class Zsh < Formula
  desc "UNIX shell (command interpreter)"
  homepage "https://www.zsh.org/"

  stable do
    url "https://www.zsh.org/pub/zsh-5.3.tar.gz"
    mirror "https://downloads.sourceforge.net/project/zsh/zsh/5.3/zsh-5.3.tar.gz"
    sha256 "1da273fa96041b395ee9f628d14f2aff08f9a62e98423a990218e2ea037b9a6d"

    # We cannot build HTML doc on HEAD, because yodl which is required for
    # building zsh.texi is not available.
    option "with-texi2html", "Build HTML documentation"
    depends_on "texi2html" => [:build, :optional]
  end

  bottle do
    sha256 "51270c500dbf6bfc81e1fa1b19ce8b147adbc717ef0c0fe2ed6f41031b056236" => :sierra
    sha256 "bb54d4104228326c7661ef9a6014b1f2ee00e9f5ae651551dfd56fed700e679d" => :el_capitan
    sha256 "d5fa17cb9ebf4c9115f66b6b8fb7ef3c535bcf2eb372668936e54591f732fc86" => :yosemite
  end

  head do
    url "git://git.code.sf.net/p/zsh/code"
    depends_on "autoconf" => :build

    option "with-unicode9", "Build with Unicode 9 character width support"
  end

  option "without-etcdir", "Disable the reading of Zsh rc files in /etc"
  option "with-unicode9", "Build with Unicode 9 character width support"

  deprecated_option "disable-etcdir" => "without-etcdir"

  depends_on "gdbm"
  depends_on "pcre"

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
      --enable-pcre
      --enable-zsh-secure-free
      --with-tcsetpgrp
    ]

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
      system "make", "install.html" if build.with? "texi2html"
    end
  end

  def caveats; <<-EOS.undent
    In order to use this build of zsh as your login shell,
    it must be added to /etc/shells.
    EOS
  end

  test do
    assert_equal "homebrew\n",
      shell_output("#{bin}/zsh -c 'echo homebrew'")
  end
end
