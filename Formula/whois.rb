class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.5.0.tar.xz"
  sha256 "64ec63339d7ad559cd6722bd3141a1e5787817bd921841a813ee17a0a34b6f3d"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any
    sha256 "83297baff5c6d2335a0a86729ba6e99890eab6368be66cd7940e793a87da13bd" => :mojave
    sha256 "f8eb5032d15433a7a77043136df27a51b984d0a405c2083cb4bd4f2f81edd0ba" => :high_sierra
    sha256 "83c15ea30627b36a65d4b9134cf455d7ef3a0fa4bc0ec05b136e04bcefca4f0f" => :sierra
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
