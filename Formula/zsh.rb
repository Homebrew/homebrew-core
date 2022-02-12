class Zsh < Formula
  desc "UNIX shell (command interpreter)"
  homepage "https://www.zsh.org/"
  url "https://downloads.sourceforge.net/project/zsh/zsh/5.8.1/zsh-5.8.1.tar.xz"
  mirror "https://www.zsh.org/pub/zsh-5.8.1.tar.xz"
  sha256 "b6973520bace600b4779200269b1e5d79e5f505ac4952058c11ad5bbf0dd9919"
  license "MIT-Modern-Variant"

  bottle do
    sha256 arm64_monterey: "750505b1f918835561d0faed812ba007b26ca6f85f658407874a7e764d05aec7"
    sha256 arm64_big_sur:  "f6150fb2971ff3e1f127d5a41e2178593723bfe83dbff1162024581aa657f790"
    sha256 monterey:       "bc2f7567c37e90c76f6d0e59fa026f00379ba764d8eb6d77d3e96775af74f99d"
    sha256 big_sur:        "56e6e6569dfa2871dbe7337b70f800698b7fecb2a40bb0130f4c41a3e8d39387"
    sha256 catalina:       "622fb66e31fbea6b09c733fc786d17f884cbadc465849885d725310edd89d3e1"
    sha256 x86_64_linux:   "abe61492a141121b3d46c06358b7760b49a866f524b96345dc070f955304cc2d"
  end

  head do
    url "https://git.code.sf.net/p/zsh/code.git", branch: "master"
    depends_on "autoconf" => :build
  end

  depends_on "ncurses"
  depends_on "pcre"

  uses_from_macos "texinfo"

  resource "htmldoc" do
    url "https://downloads.sourceforge.net/project/zsh/zsh-doc/5.8.1/zsh-5.8.1-doc.tar.xz"
    mirror "https://www.zsh.org/pub/zsh-5.8.1-doc.tar.xz"
    sha256 "8b9cb53d6432f13e9767a8680b642e8e8a52c7f1b8decd211756ca20c667f917"
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
