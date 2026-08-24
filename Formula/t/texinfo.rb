class Texinfo < Formula
  desc "Official documentation format of the GNU project"
  homepage "https://www.gnu.org/software/texinfo/"
  url "https://ftpmirror.gnu.org/gnu/texinfo/texinfo-7.3.tar.xz"
  mirror "https://ftp.gnu.org/gnu/texinfo/texinfo-7.3.tar.xz"
  sha256 "51f74eb0f51cfa9873b85264dfdd5d46e8957ec95b88f0fb762f63d9e164c72e"
  license "GPL-3.0-or-later"
  revision 1
  compatibility_version 1

  bottle do
    sha256 arm64_tahoe:   "17f0c0cf884670ec1cb6ef941804649a40a46599f3157d66eb3462cc6555bfdd"
    sha256 arm64_sequoia: "8fee9bab9242aba8f21e468b7e3261ce8c4bf8963c0b5590329131a129d2a197"
    sha256 arm64_sonoma:  "72fa6078b2d0f710a791a9522ad99893dc683ad1cab898cdb55c8d65adb597be"
    sha256 tahoe:         "3549fa66f7921336908d81eeb9fc922ea01017ffd6ff5aa35f819d29e8b03e3e"
    sha256 sequoia:       "7b4c695db9ec5cd2dc8a7c73311b4ba1cbc17f60c2b6f583afc6d45801059de3"
    sha256 sonoma:        "c6718d55dfbfc3fc6b7eafbcf45737ae460f2b5824c6499a0361af0b343712cf"
    sha256 arm64_linux:   "238df7fe5e95a98dfcc37b537bf236ccd156fea72d616f0fbc3ed4f6c4561376"
    sha256 x86_64_linux:  "1efa090b410b8c515e4d373f33abcf90d0ccb05bbf353a34ce2351f1f324c5ae"
  end

  uses_from_macos "ncurses"
  uses_from_macos "perl"

  on_linux do
    depends_on "libunistring"
  end

  def install
    system "./configure", "--disable-install-warnings", *std_configure_args
    system "make", "install"
    doc.install Dir["doc/refcard/txirefcard*"]

    (libexec/"post-install").write <<~SH
      #!/bin/sh
      info_dir="#{HOMEBREW_PREFIX}/share/info/dir"
      rm -f "$info_dir"
      for file in "#{HOMEBREW_PREFIX}/share/info/"*.info "#{HOMEBREW_PREFIX}/share/info/"*.info.gz; do
        [ -e "$file" ] || continue
        "#{opt_bin}/install-info" --quiet "$file" "$info_dir" || true
      done
    SH
    chmod 0755, libexec/"post-install"
  end

  post_install_steps do
    run "post-install", base: :libexec
  end

  test do
    (testpath/"test.texinfo").write <<~EOS
      @ifnottex
      @node Top
      @top Hello World!
      @end ifnottex
      @bye
    EOS

    system bin/"makeinfo", "test.texinfo"
    assert_match "Hello World!", (testpath/"test.info").read
  end
end
