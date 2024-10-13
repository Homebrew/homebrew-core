class Zsh < Formula
  desc "UNIX shell (command interpreter)"
  homepage "https://www.zsh.org/"
  license all_of: [
    "MIT-Modern-Variant",
    "GPL-2.0-only", # Completion/Linux/Command/_qdbus, Completion/openSUSE/Command/{_osc,_zypper}
    "GPL-2.0-or-later", # Completion/Unix/Command/_darcs
    "ISC", # Src/openssh_bsd_setres_id.c
  ]

  # TODO: Switch to `pcre2` on next release and remove stable block
  stable do
    url "https://downloads.sourceforge.net/project/zsh/zsh/5.9/zsh-5.9.tar.xz"
    mirror "https://www.zsh.org/pub/zsh-5.9.tar.xz"
    sha256 "9b8d1ecedd5b5e81fbf1918e876752a7dd948e05c1a0dba10ab863842d45acd5"

    depends_on "pcre"
  end

  livecheck do
    url "https://sourceforge.net/projects/zsh/rss?path=/zsh"
  end

  bottle do
    rebuild 2
    sha256 arm64_sequoia:  "15e9037c0726a957c252406d8dcd10b92bf96f080ffd6a21f252f88cfe2328b2"
    sha256 arm64_sonoma:   "2724270ffc9ec802c84de94466076bbff2e9de712dc4542e2b98646d5bdf9120"
    sha256 arm64_ventura:  "de824bdff0cf68af18e1ca615d3e0646968a9cc0411cde518c86ff4e446e75ed"
    sha256 arm64_monterey: "9f2b18137c50145752b9c64f02a2be3ffbfedfcbff5b91ebe3f0d20358fe2a07"
    sha256 sonoma:         "ab60dacfc4fa57a741cd735b268ef64e51bab181b39cfb3846f2a546c22793ff"
    sha256 ventura:        "3e0713581f6c028b856556e9f5e2201e9fd9d333bc13fc6156bdb0c58d097626"
    sha256 monterey:       "e09b2792c4d231b4917ebe8c3565ba66c22d15c5242043af47e3075f50470839"
    sha256 x86_64_linux:   "28d2fb59ee1c2db1ea2a0a2923201fde83b4b8cb2891ac3bbee288e7cf9cb2c6"
  end

  head do
    url "https://git.code.sf.net/p/zsh/code.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "pcre2"
  end

  depends_on "ncurses"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  resource "htmldoc" do
    url "https://downloads.sourceforge.net/project/zsh/zsh-doc/5.9/zsh-5.9-doc.tar.xz"
    mirror "https://www.zsh.org/pub/zsh-5.9-doc.tar.xz"
    sha256 "6f7c091249575e68c177c5e8d5c3e9705660d0d3ca1647aea365fd00a0bd3e8a"
  end

  def install
    # Fix compile with newer Clang. Remove in the next release
    # Ref: https://sourceforge.net/p/zsh/code/ci/ab4d62eb975a4c4c51dd35822665050e2ddc6918/
    ENV.append_to_cflags "-Wno-implicit-int" if DevelopmentTools.clang_build_version >= 1403

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
    system bin/"zsh", "-c", "zmodload zsh/pcre"
  end
end
