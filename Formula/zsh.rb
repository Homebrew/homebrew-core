class Zsh < Formula
  desc "UNIX shell (command interpreter)"
  homepage "https://www.zsh.org/"
  url "https://downloads.sourceforge.net/project/zsh/zsh/5.9/zsh-5.9.tar.xz"
  mirror "https://www.zsh.org/pub/zsh-5.9.tar.xz"
  sha256 "9b8d1ecedd5b5e81fbf1918e876752a7dd948e05c1a0dba10ab863842d45acd5"
  license "MIT-Modern-Variant"

  livecheck do
    url "https://sourceforge.net/projects/zsh/rss?path=/zsh"
  end

  bottle do
    sha256 arm64_monterey: "1c6d208a7aa0601b25d04c5d41a393424b1094cf188e5b0c80fafc6e1e2755ef"
    sha256 arm64_big_sur:  "0a93821dee76829dac49770d4b32d08d0678272c43937e3858d7f901bab86cd6"
    sha256 monterey:       "b9a38fa0344b187333771a5585ad2d01c27e69a7e5362ba3fc8d7389aa3279f3"
    sha256 big_sur:        "722236bd8c9a094e1eca09263f5e83a94d4c97c2ca797804eef4f9564ef729ec"
    sha256 catalina:       "64c8757cc6db0247fb9f604ff84f61726fb5d91318c566157fa2957782040403"
    sha256 x86_64_linux:   "fb0b59e7b1407323ea06b7c757de4d75bbcfb0836ce05857b0b2cf7816a231e0"
  end

  head do
    url "https://git.code.sf.net/p/zsh/code.git", branch: "master"
    depends_on "autoconf" => :build
  end

  depends_on "ncurses"
  depends_on "pcre"

  uses_from_macos "texinfo"

  resource "htmldoc" do
    url "https://downloads.sourceforge.net/project/zsh/zsh-doc/5.9/zsh-5.9-doc.tar.xz"
    mirror "https://www.zsh.org/pub/zsh-5.9-doc.tar.xz"
    sha256 "6f7c091249575e68c177c5e8d5c3e9705660d0d3ca1647aea365fd00a0bd3e8a"
  end

  def install
    # Work around configure issues with Xcode 12
    # https://www.zsh.org/mla/workers/2020/index.html
    # https://github.com/Homebrew/homebrew-core/issues/64921
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

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
