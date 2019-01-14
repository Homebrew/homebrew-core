class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.4.0.tar.xz"
  sha256 "3775ae0cfaa6dd8d886e5233c4826225cddcb88c99c2a08130d14e15fe58e378"
  revision 2
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any
    sha256 "e932ffe0a27c3c9178ee3aff41f0bebdfcc3e3ffc7b0049cdece6f9612056d48" => :mojave
    sha256 "7954ae0228a28a018d674d524679314e5f43c9b6ef01f78c49cb243ceae45dcf" => :high_sierra
    sha256 "7d9dc40a7db1cb00ba681772339c404fed21d1ef16475be390946187375525ae" => :sierra
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
