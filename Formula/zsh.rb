class Zsh < Formula
  desc "UNIX shell (command interpreter)"
  homepage "https://www.zsh.org/"
  url "https://www.zsh.org/pub/zsh-5.4.1.tar.xz"
  mirror "https://downloads.sourceforge.net/project/zsh/zsh/5.4.1/zsh-5.4.1.tar.xz"
  sha256 "94cbd57508287e8faa081424509738d496f5f41e32ed890e3a5498ce05d3633b"

  bottle do
    sha256 "9b02aa96d53e036e3fefe5c529afc8b2bd286a53494286002b1fc05fabe57204" => :sierra
    sha256 "a9bc3bdff0e13ebec0af772b979881411d75abd95a282ab1a8c12c20aa772dd3" => :el_capitan
    sha256 "c35759bba5a25a8eebd36d90427a4feacba8d41249ba272055fbfd05d3f92bf4" => :yosemite
  end

  head do
    url "https://git.code.sf.net/p/zsh/code.git"
    depends_on "autoconf" => :build
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
    end
  end

  test do
    assert_equal "homebrew", shell_output("#{bin}/zsh -c 'echo homebrew'").chomp
  end
end
