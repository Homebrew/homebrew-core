class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.5.16.tar.xz"
  sha256 "0a818f56c4bb909cf8665766cb683931de52901d6a33627d51b1005add3cdb27"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git", branch: "next"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "90bde96b163eef38a8ea8eb0e424cae9744267cf0136b68dcfa0d643772d1fa2"
    sha256 cellar: :any,                 arm64_monterey: "f39db86ba58274c6048dad08d107823c61ea283fda5c528faee8367e1f1283ab"
    sha256 cellar: :any,                 arm64_big_sur:  "d4787a3bcdc5c763d9d5adbac63b30925f24ad7520352b2c8dac2e48ef14a81b"
    sha256 cellar: :any,                 ventura:        "29c062358d808c03d147107264187e8b36aafcf63e4be73aa9a8376458fc0dd5"
    sha256 cellar: :any,                 monterey:       "3049b57aea428e70563f2bfb49976c0ca5f29e28d2f17dde7023f7add8dc2359"
    sha256 cellar: :any,                 big_sur:        "c527c806c0def5d7c76a914cfdd7f4179c8a85aa4f408d9ce97e2aa2f6321be0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a92bb7e7b763d6f4311ec1abf2dfcfa4d9dafdca65baba735a78ef340ec39257"
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
