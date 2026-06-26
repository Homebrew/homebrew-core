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
    sha256 arm64_tahoe:   "19d5c07ae6c903d410ce5d4a2bc7577b64d960d2f4fec8659a1855102efcdafd"
    sha256 arm64_sequoia: "17ca8e77c287c86c8ef84cb6d29d04ba880a3640d8f568a33e2344cc71dbaa08"
    sha256 arm64_sonoma:  "74aae0cb5ef080e857156a270ea11171b2d9209cf1ff3a0520291f6ff8bc3d67"
    sha256 sonoma:        "0c831556a632b10585c62e12eac0043e23a2693b42c9e66eed35203535d01446"
    sha256 arm64_linux:   "bee42cb9e4a63c5dfcaae67e0988946d536a474d5fcd876fd3e12139b2d5b461"
    sha256 x86_64_linux:  "61309af530692ca2440f75459731e5e7260148e65877d4a05747122f4d628093"
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
    # Fix compile with newer Clang. Remove in the next release
    # Ref: https://sourceforge.net/p/zsh/code/ci/ab4d62eb975a4c4c51dd35822665050e2ddc6918/
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

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
