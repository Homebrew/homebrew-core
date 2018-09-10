class Zsh < Formula
  desc "UNIX shell (command interpreter)"
  homepage "https://www.zsh.org/"
  url "https://downloads.sourceforge.net/project/zsh/zsh/5.6.1/zsh-5.6.1.tar.xz"
  mirror "https://www.zsh.org/pub/zsh-5.6.1.tar.xz"
  sha256 "9566753f317d31b808b6b63a5622c71f25d473a6b5fea5c35ab1c7ed96fbb3e8"

  bottle do
    sha256 "0a005a146f095456fe122a0e5d5a6d783e0779b831f8e209e9c3a70d58d75a0e" => :mojave
    sha256 "dc77c71144f5d953f73dc1f9214ea2ef70061ddb902708e21558507cb925b6c0" => :high_sierra
    sha256 "aed8b15cc590f43cfe680b5619cb8649437dfdc2a3c8f624864c155c794f45e8" => :sierra
    sha256 "56a757d55baf4f709dda5b89d036412d5aad5f74a508950186915b79231c9d26" => :el_capitan
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
    url "https://downloads.sourceforge.net/project/zsh/zsh-doc/5.6.1/zsh-5.6.1-doc.tar.xz"
    mirror "https://www.zsh.org/pub/zsh-5.6.1-doc.tar.xz"
    sha256 "b64a290c0176d8844d0bd7349b59078536f798cfc7f4eab175595dd75ae04896"
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
