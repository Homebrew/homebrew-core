class Zsh < Formula
  desc "UNIX shell (command interpreter)"
  homepage "https://www.zsh.org/"
  url "https://downloads.sourceforge.net/project/zsh/zsh/5.8/zsh-5.8.tar.xz"
  mirror "https://www.zsh.org/pub/zsh-5.8.tar.xz"
  sha256 "dcc4b54cc5565670a65581760261c163d720991f0d06486da61f8d839b52de27"
  license "MIT-Modern-Variant"
  revision 1

  bottle do
    sha256 arm64_monterey: "d2a170f7ddb628efabfe7c9909e2d769980fa29d38739d74530dba83ef3b6795"
    sha256 arm64_big_sur:  "01ae59e3ea21dd7691120aec89552e4f4c10c6489a24b9cc23256129e3cbe7b6"
    sha256 monterey:       "768904862c98184cdd5e204469c96678652b323ad7d108807dd8afe6cc5c51c0"
    sha256 big_sur:        "a93717bcbb1a41829ac7549f7dea0e2be4bb11985be734f03801150338d6b8e6"
    sha256 catalina:       "aaf19f69f79ac2ef80ff31d3b2f0017f400bf40022f8626d5ae046990961a5f5"
    sha256 mojave:         "a40a54e4b686eb75f04e7dcc57391245a4f6b08a39825f7f6ebc9f76ebcbff46"
    sha256 high_sierra:    "edfbc09a9571fadf351e0f94e545a88aa33763518a3330c0bae497a6a259d63f"
    sha256 x86_64_linux:   "f37a99a35ac7b20d78a5e0d83420b4ad74d63cedc426cfd3d964cebe79935183"
  end

  head do
    url "https://git.code.sf.net/p/zsh/code.git", branch: "master"
    depends_on "autoconf" => :build
  end

  depends_on "ncurses"
  depends_on "pcre"

  uses_from_macos "texinfo"

  resource "htmldoc" do
    url "https://downloads.sourceforge.net/project/zsh/zsh-doc/5.8/zsh-5.8-doc.tar.xz"
    mirror "https://www.zsh.org/pub/zsh-5.8-doc.tar.xz"
    sha256 "9b4e939593cb5a76564d2be2e2bfbb6242509c0c56fd9ba52f5dba6cf06fdcc4"
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
