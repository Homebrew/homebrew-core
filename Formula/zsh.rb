class Zsh < Formula
  desc "UNIX shell (command interpreter)"
  homepage "https://www.zsh.org/"
  revision 1

  stable do
    url "https://downloads.sourceforge.net/project/zsh/zsh/5.3.1/zsh-5.3.1.tar.xz"
    mirror "https://www.zsh.org/pub/zsh-5.3.1.tar.xz"
    sha256 "fc886cb2ade032d006da8322c09a7e92b2309177811428b121192d44832920da"

    # We cannot build HTML doc on HEAD, because yodl which is required for
    # building zsh.texi is not available.
    option "with-texi2html", "Build HTML documentation"
    depends_on "texi2html" => [:build, :optional]

    # Remove for > 5.3.1
    # Upstream commit from 10 Jan 2017 "40305: fix some problems redisplaying
    # command line after"
    # See https://github.com/zsh-users/zsh/commit/34656ec2f00d6669cef56afdbffdd90639d7b465
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/0b7bf62/zsh/fix-autocomplete.patch"
      sha256 "4f70882293e2d936734c7ddf40e296da7ef5972fa6f43973b9ca68bf028e2c38"
    end
  end

  bottle do
    sha256 "054988ed570c911f1758f08b71777707154101b180570577d1d4a4380043a041" => :sierra
    sha256 "8fb846fbfb27744a50b4e5cff2767f6fca49016f356bd6273dedfc8e2abdd919" => :el_capitan
    sha256 "4ca1f10d588cedb061826c6a6aa0bbde233627cf86188deed0bd07321f91d739" => :yosemite
  end

  head do
    url "https://git.code.sf.net/p/zsh/code.git"
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

  test do
    assert_equal "homebrew\n",
      shell_output("#{bin}/zsh -c 'echo homebrew'")
  end
end
