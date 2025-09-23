class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://github.com/rfc1036/whois"
  url "https://github.com/rfc1036/whois/archive/refs/tags/v5.6.4.tar.gz"
  sha256 "95a3320940dbc1843c427ea85e7cc5e1d711692429fff4be23fadecd66cb9d24"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git", branch: "next"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3d116f67607fd2889e75abb66a69c21c2a4ddd279e73e1fcb4c63ee41e8d05bb"
    sha256 cellar: :any,                 arm64_sequoia: "c90c29535593c303565fe0e4f91e13c1d1d724c026406fbce800f4e640798532"
    sha256 cellar: :any,                 arm64_sonoma:  "fcc6a1e6d7bf37e245d4c848c027bac5089ece77167c0df13bbfb8dd5d16d835"
    sha256 cellar: :any,                 arm64_ventura: "005f13f2b98eade99bd67c52b9ae073c02f89f551267d1caa40ccb0300e0c337"
    sha256 cellar: :any,                 sonoma:        "96a5e14b31c60e503f8cd4df953e765f3bcc900c57070d30def007ed5e57159c"
    sha256 cellar: :any,                 ventura:       "9d82ce8c72dc3545b736e47e09e6243218a633a74b678974e30869de335c6e11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6e7164aca7d53649f92237e5c90ad486e45c0ae6203772d85109159d3563d41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c34edc9f866f9ba359b4d756c3048f8014412aef861f23658fdb8b36a9572c43"
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
