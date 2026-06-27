class Zsh < Formula
  desc "UNIX shell (command interpreter)"
  homepage "https://www.zsh.org/"
  license all_of: [
    "MIT-Modern-Variant",
    "GPL-2.0-only", # Completion/Linux/Command/_qdbus, Completion/openSUSE/Command/{_osc,_zypper}
    "GPL-2.0-or-later", # Completion/Unix/Command/_darcs
    "ISC", # Src/openssh_bsd_setres_id.c
  ]

  stable do
    url "https://downloads.sourceforge.net/project/zsh/zsh/5.9.1/zsh-5.9.1.tar.xz"
    mirror "https://www.zsh.org/pub/zsh-5.9.1.tar.xz"
    sha256 "5d20bec03f981dc4e9a09ec245e7415388ff641f79c5c5c416b5042e58d8280d"

    resource "htmldoc" do
      url "https://downloads.sourceforge.net/project/zsh/zsh-doc/5.9.1/zsh-5.9.1-doc.tar.xz"
      mirror "https://www.zsh.org/pub/zsh-5.9.1-doc.tar.xz"
      sha256 "c40b34cb332ddbee627f8d9a3e4cb92e2c851942b33e6c178b1d571375b80f67"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url "https://sourceforge.net/projects/zsh/rss?path=/zsh"
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "e4732c259117569494b4c04b6ee03352c4bba396ddd38eaf5338f09576f6e545"
    sha256 arm64_sequoia: "b5a6818bc0fac64b34be2f146bf2f5e88ac1bce7ccfaebeec041264dd17bcab6"
    sha256 arm64_sonoma:  "ce3731931aa1596e1c430f52b6c1b85e81dbe6b2f4022259706a7fa8ba4d78bd"
    sha256 sonoma:        "a194c399b7b4b1064b425ced7aef77cbb67144516d5dd1b6681c7cd86c95538c"
    sha256 arm64_linux:   "dda9a28f94e4b732323869edfe11130b3252df3f47f36f56f02d4147db13877e"
    sha256 x86_64_linux:  "663fd1cccd978d5eac68265cdd4b605783fded2f528557cb21aa9e590351873d"
  end

  head do
    url "https://git.code.sf.net/p/zsh/code.git", branch: "master"
    depends_on "autoconf" => :build
  end

  depends_on "ncurses"
  depends_on "pcre2"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "Util/preconfig" if build.head?

    args = %W[
      --enable-fndir=#{pkgshare}/functions
      --enable-scriptdir=#{pkgshare}/scripts
      --enable-site-fndir=#{HOMEBREW_PREFIX}/share/zsh/site-functions
      --enable-site-scriptdir=#{HOMEBREW_PREFIX}/share/zsh/site-scripts
      --enable-runhelpdir=#{pkgshare}/help
      --enable-maildir-support
      --enable-multibyte
      --enable-pcre
      --enable-zsh-secure-free
      --enable-unicode9
      --enable-etcdir=/etc
      --with-tcsetpgrp
    ]

    args << "--enable-cap" if OS.linux?

    system "./configure", *args, *std_configure_args, "DL_EXT=bundle"

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
    system bin/"zsh", "-c", "zmodload zsh/pcre"
  end
end
