class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.5.10.tar.xz"
  sha256 "2391037b079695d0e9fd3c85ab021809a539cf093d25b6c51ca65019a54158dd"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git", branch: "next"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7853673d3484780e46e602371bb2c2fe6c10372d3469ccae4115c9a87b27bba8"
    sha256 cellar: :any,                 arm64_big_sur:  "970ef127f0ed9b5585811ae9073dd3afbcd6127338f8c3b89b081195d7ec4b13"
    sha256 cellar: :any,                 monterey:       "a2a1426eeca9d7252d556051039be164a8962a791a4992377044c0081932a75c"
    sha256 cellar: :any,                 big_sur:        "2292a0ceec5f8357e7cf1f3cf4fdd9742d098745e4b2f9696b391861d3d17b9c"
    sha256 cellar: :any,                 catalina:       "062ff59198a48c66bbbbe665b047bf39d6f59b9f6c8bbefc0e76a020cd432d5c"
    sha256 cellar: :any,                 mojave:         "0f90a109c12c82e20e16a59ded524758576724ecf8eab092dce7cbf7535b884a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfcef4c75873b35a6d7e7b33641756c7762f188468fbfd222278f7305523c2e5"
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
