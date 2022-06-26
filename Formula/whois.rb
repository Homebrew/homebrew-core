class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.5.13.tar.xz"
  sha256 "62e613f116d5635aea6684238db00b030a6602ffc79462e4a0a8e62cb184b5d7"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git", branch: "next"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3b8a8d276e28ba2565cde46aede77fcfdbe014693aa336d50e17002324c9461f"
    sha256 cellar: :any,                 arm64_big_sur:  "1f6cde04177d329370ef24f19f61f30da1f8a618da92b2184432a72da57a7e4c"
    sha256 cellar: :any,                 monterey:       "033954b7cc2e31dafcbae6cb07913037247b9cbf21be439889fdd2cfdd2ee437"
    sha256 cellar: :any,                 big_sur:        "05f047c3e6808289fcd5061fb0c3a96f267b3287fdd282e953ea179e20e60902"
    sha256 cellar: :any,                 catalina:       "656da1332e3434bcdb20c1a18fab72ea96002433281b0bc8060544e98764c5bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac4e1d3fe13d6e208d613c446820f3838b91e30f04735a5951830c58454e7146"
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build
  depends_on "libidn2"

  def install
    ENV.append "LDFLAGS", "-L/usr/lib -liconv" if OS.mac?

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
    system "#{bin}/whois", "brew.sh"
  end
end
