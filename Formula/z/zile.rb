class Zile < Formula
  desc "Text editor development kit"
  homepage "https://www.gnu.org/software/zile/"
  # Before bumping to a new version, check the NEWS file to make sure it is a
  # stable release: https://git.savannah.gnu.org/cgit/zile.git/plain/NEWS
  # For context, see: https://github.com/Homebrew/homebrew-core/issues/67379
  url "https://ftpmirror.gnu.org/gnu/zile/zile-2.6.4.tar.gz"
  mirror "https://ftp.gnu.org/gnu/zile/zile-2.6.4.tar.gz"
  sha256 "d5d44b85cb490643d0707e1a2186f3a32998c2f6eabaa9481479b65caeee57c0"
  license "GPL-3.0-or-later"
  version_scheme 1

  bottle do
    sha256 arm64_tahoe:   "efce10489a93b24ac8a9312e993a57b981b38fc3decfc9f36e37ca7cfa49cff5"
    sha256 arm64_sequoia: "0d218900aa4e2a8504325c958be05c5e888d83b319dd7f69c4a47d6bd8ad4c2b"
    sha256 arm64_sonoma:  "64b800f85f1370a2a560b128b16b767dae780c8adfac7384ec8c493c1e998374"
    sha256 arm64_ventura: "93a981404b8329b697eaa73bc973bfcac3b941e22ce378c267d8dc4d8b413e7f"
    sha256 sonoma:        "e2026f3432e32618c9627439100db48f8a36654cf90dbf22c2baa25edc2bb1f5"
    sha256 ventura:       "c029f82ef50328547756ce4932f995994f42a6c262fd286e596862df8fa22a64"
    sha256 arm64_linux:   "da6586cbaebf99b3e2656fcd87abaf64f021bf14c9f9f9208acbc8819bc0ec26"
    sha256 x86_64_linux:  "b580ca192a5f2714cb7cb91ac4d101794c4ae98b1c799c87f73c9970be2bcb93"
  end

  depends_on "help2man" => :build
  depends_on "pkgconf" => :build
  depends_on "bdw-gc"
  depends_on "glib"
  depends_on "libgee"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Work around Vala issue https://gitlab.gnome.org/GNOME/vala/-/issues/1408
    # which causes src/eval.vala:87:32: error: incompatible function pointer types passing
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zile --version")
  end
end
