class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.4.2.tar.xz"
  sha256 "eee33a3b3a56912fbf115a7dd24ed60314e2707a3ad6aa604ca2752c1ed01f57"
  revision 1
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any
    sha256 "8b33d363d3e5ac7afdc51c63be8f8d4bfa6a6f07d0eebf6466807a0c2731bfca" => :mojave
    sha256 "6da5f1c5004ba6e426c01957326bda043e02dde399719dd4e86630a5a673fcd6" => :high_sierra
    sha256 "325df08997f0548a24bd91526e1541466a71e463c72eaba2e7ae321fe2cb39e7" => :sierra
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
