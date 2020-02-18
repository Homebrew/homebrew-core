class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.5.6.tar.xz"
  sha256 "cba1e9000c60950f46a96ba23e8eea8aee240a2b8560e63a6bfb33f9034af14e"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any
    sha256 "fbdbe5c9d7e53c178d38dd2cc96f9b7c7c7e6d66ac3c99612c934c9fae09c434" => :catalina
    sha256 "5433f102ffe597e2eb1ed81285967701b7a77bbe79ddcba9dc2bc7d53106fe1e" => :mojave
    sha256 "ad4c83c260322ab6eec10cd3e4a26603d60d48ca103984d47ee3bf76af3b43ae" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libidn2"

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
