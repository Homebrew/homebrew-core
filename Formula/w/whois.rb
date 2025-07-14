class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://github.com/rfc1036/whois"
  url "https://github.com/rfc1036/whois/archive/refs/tags/v5.6.2.tar.gz"
  sha256 "0773cf51fc9a980af3954fb3859c7673f8bb7901c5be4041a12c926609edeb89"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git", branch: "next"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5c8577a0e2803e96e43e1f21b39754d031b8b6dbce1ceea190100c9ccc27a2f6"
    sha256 cellar: :any,                 arm64_sonoma:  "c74431c6be171166545e8d0e97768f05eddfbe38d924cadcf488437604cb5645"
    sha256 cellar: :any,                 arm64_ventura: "4eca16ae0e9a9d3cd778ccb1a0ee22e004284fbdbd7853ef8b69cb597378c1b0"
    sha256 cellar: :any,                 sonoma:        "07180940868e2bbf29b7ec112efe6158087871935eb794485560711b21e22cc1"
    sha256 cellar: :any,                 ventura:       "0665a16b1f2e2c006db927451a4bdaf4ef2fd486cec22a9e2b3172f3ab4be30e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5826a1de1904fb6a257a277fb305852ad9e9997e36c6687bc61c1e3a22a2350e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1987b3c0ef46aeeb8fa7c09c2023deb9a9f33165cdff053dde38a1ffa762efb2"
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

    system "make", "whois", have_iconv
    bin.install "whois"
    man1.install "whois.1"
    man5.install "whois.conf.5"
  end

  test do
    system bin/"whois", "brew.sh"
  end
end
