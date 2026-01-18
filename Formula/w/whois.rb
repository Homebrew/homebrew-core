class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://github.com/rfc1036/whois"
  url "https://github.com/rfc1036/whois/archive/refs/tags/v5.6.5.tar.gz"
  sha256 "99510048033408eae5cc3f1f421121a1f33147196b7017ebaace6e56352680f5"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git", branch: "next"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3f7eecdec4dc6dec07980e2908f451df7a3e778fab47785fc6615c7b8db3ea72"
    sha256 cellar: :any,                 arm64_sequoia: "46f6549d331ea0d7b316d4bdee34afc953d3b7c9e3a35bece1089d63c767f4c7"
    sha256 cellar: :any,                 arm64_sonoma:  "fdb9bc05c21e38b8121c7bb387cad4d2725f95d863b3dcbeef81d80a5ada58c9"
    sha256 cellar: :any,                 sonoma:        "fdf27190150b9938875bb51cc555559b19581cf54852275f6c014de3e5ae3432"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2f57c068b7e808b997cfbad518cd35f9543908165a29212c9c1570e3eb58cdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4337035ef19d8e7c73f9abb7f4bbb775e888a71ad08352bd7d9450dbdaaa155"
  end

  keg_only :provided_by_macos

  depends_on "pkgconf" => :build
  depends_on "libidn2"

  def install
    ENV.append "LDFLAGS", "-L/usr/lib -liconv" if OS.mac?

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    have_iconv = if OS.mac?
      "HAVE_ICONV=1"
    else
      "HAVE_ICONV=0"
    end

    system "make", "install-whois", "prefix=#{prefix}", have_iconv
  end

  test do
    system bin/"whois", "brew.sh"
  end
end
