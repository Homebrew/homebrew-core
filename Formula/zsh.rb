class Zsh < Formula
  desc "UNIX shell (command interpreter)"
  homepage "https://www.zsh.org/"
  url "https://downloads.sourceforge.net/project/zsh/zsh/5.8/zsh-5.8.tar.xz"
  mirror "https://www.zsh.org/pub/zsh-5.8.tar.xz"
  sha256 "dcc4b54cc5565670a65581760261c163d720991f0d06486da61f8d839b52de27"

  bottle do
    sha256 "a24afee5cc1af2b139b6afb8963992b3fb22a4b9fbfa02402ac17e6bfa66a27a" => :catalina
    sha256 "793d87f67e64a5e01dfdea890af218e4779a2df514d395b956e464129af16fd7" => :mojave
    sha256 "6656fe9aa5d5cbaff49bc9c1ccf17b7d96d21036ac44c9181bd35c57dc38b450" => :high_sierra
    sha256 "008dfc844b88fcd61925233b08f0d78b2851bf2901320a5f6ee975da4b8604e3" => :sierra
  end

  head do
    url "https://git.code.sf.net/p/zsh/code.git"
    depends_on "autoconf" => :build
  end

  depends_on "ncurses"
  depends_on "pcre"

  resource "htmldoc" do
    url "https://downloads.sourceforge.net/project/zsh/zsh-doc/5.8/zsh-5.8-doc.tar.xz"
    mirror "https://www.zsh.org/pub/zsh-5.8-doc.tar.xz"
    sha256 "9b4e939593cb5a76564d2be2e2bfbb6242509c0c56fd9ba52f5dba6cf06fdcc4"
  end

  def install
    system "Util/preconfig" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--enable-fndir=#{pkgshare}/functions",
                          "--enable-scriptdir=#{pkgshare}/scripts",
                          "--enable-site-fndir=#{HOMEBREW_PREFIX}/share/zsh/site-functions",
                          "--enable-site-scriptdir=#{HOMEBREW_PREFIX}/share/zsh/site-scripts",
                          "--enable-runhelpdir=#{pkgshare}/help",
                          "--enable-cap",
                          "--enable-maildir-support",
                          "--enable-multibyte",
                          "--enable-pcre",
                          "--enable-zsh-secure-free",
                          "--enable-unicode9",
                          "--enable-etcdir=/etc",
                          "--with-tcsetpgrp",
                          "DL_EXT=bundle"

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
