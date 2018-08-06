class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/w/whois/whois_5.3.2.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/w/whois/whois_5.3.2.tar.xz"
  sha256 "79714ba89172bca08a2443f59885daa4af0c5f8d6a49bc9e7f2a83559a286354"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a44e35933c977f5510daea2b8486e7843edf26551b077b718508471902653b06" => :high_sierra
    sha256 "e6ca1417a99c060555de387381139d1ba3f0181bf92f19ae30d3a23558f6616c" => :sierra
    sha256 "d40af5a93e8a0b7daa1ebb5de3a25a00cd834283c18f26957e33aec3329ef8b3" => :el_capitan
  end

  option "with-libidn2", "Compile with IDN support"

  depends_on "pkg-config" => :build if build.with? "libidn2"
  depends_on "libidn2" => :optional

  def install
    ENV.append "LDFLAGS", "-L/usr/lib -liconv"

    system "make", "whois", "HAVE_ICONV=1"
    bin.install "whois"
    man1.install "whois.1"
    man5.install "whois.conf.5"
  end

  def caveats; <<~EOS
    Debian whois has been installed as `whois` and may shadow the
    system binary of the same name.
  EOS
  end

  test do
    system "#{bin}/whois", "brew.sh"
  end
end
