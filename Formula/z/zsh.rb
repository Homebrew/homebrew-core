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
    url "https://downloads.sourceforge.net/project/zsh/zsh/5.9.2/zsh-5.9.2.tar.xz"
    mirror "https://www.zsh.org/pub/zsh-5.9.2.tar.xz"
    sha256 "36fa734374b44783582cec09bcd67822e2f992c779ec1624ab5596df078d2f81"

    resource "htmldoc" do
      url "https://downloads.sourceforge.net/project/zsh/zsh-doc/5.9.2/zsh-5.9.2-doc.tar.xz"
      mirror "https://www.zsh.org/pub/zsh-5.9.2-doc.tar.xz"
      sha256 "020ee644be1749507b282e619cdcd95c56ff36144e79b7a3c245458aacd9458f"

      livecheck do
        formula :parent
      end
    end
  end

  livecheck do
    url "https://sourceforge.net/projects/zsh/rss?path=/zsh"
  end

  bottle do
    sha256 arm64_tahoe:   "7618b2874959eecd76463c8d78747074e94121074b7df1a663b8c01e0155c280"
    sha256 arm64_sequoia: "2755dbf52a9eb647285732df520d3fd202b6f7d815c761386e6dd57b0bedf9bf"
    sha256 arm64_sonoma:  "991385b48f8767e6119df36c1c400f9697b2f40e157e7df5b1229c2b6aea530f"
    sha256 sonoma:        "6a59dc38fe84a329977fb79f76f84cce057e23c99930652dd188c0da0f560af9"
    sha256 arm64_linux:   "e516bc11ee0252de694e5da3caa775284d9f0696389a35ac85de388afc37c5f7"
    sha256 x86_64_linux:  "36eb699ea0d90cea4cc87514dfb0bc4ee853af432fdbc28688f314fd5a8d9dd6"
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
