class Zsh < Formula
  desc "UNIX shell (command interpreter)"
  homepage "https://www.zsh.org/"
  url "https://downloads.sourceforge.net/project/zsh/zsh/5.4.1/zsh-5.4.1.tar.xz"
  mirror "https://www.zsh.org/pub/zsh-5.4.1.tar.xz"
  sha256 "94cbd57508287e8faa081424509738d496f5f41e32ed890e3a5498ce05d3633b"
  revision 1

  bottle do
    sha256 "825bbbfdddd3908544bd9bbca9054c7316869cd3fa4c31f9c0d2f4d732bb1d84" => :high_sierra
    sha256 "b791878b6d2251a51ac41513d3f575f40578af97ded3293dc0c71d4ba2b65dca" => :sierra
    sha256 "37813f7b6bd05cda00710ce676206365c995a58735a9006ca41e35d613cf263b" => :el_capitan
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

  resource "htmldoc" do
    url "https://downloads.sourceforge.net/project/zsh/zsh-doc/5.4.1/zsh-5.4.1-doc.tar.xz"
    mirror "https://www.zsh.org/pub/zsh-5.4.1-doc.tar.xz"
    sha256 "b8b1a40aeec852806ad2b74b0a0c534320bf517e2fe2a087c0c9d39e75dc29f1"
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

      resource("htmldoc").stage do
        (pkgshare/"htmldoc").install Dir["Doc/*.html"]
      end
    end
  end

  test do
    assert_equal "homebrew", shell_output("#{bin}/zsh -c 'echo homebrew'").chomp
  end
end
