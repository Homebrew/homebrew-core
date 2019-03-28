class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.4.2.tar.xz"
  sha256 "eee33a3b3a56912fbf115a7dd24ed60314e2707a3ad6aa604ca2752c1ed01f57"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any
    sha256 "66e068933f97c0f7afc1f53eadca1befbd739295c2384343d35595008cd8c5a3" => :mojave
    sha256 "460c91fbfe20fa011af0e912f6139ec87de04c8a34fb1f0d28b29dd602bac53b" => :high_sierra
    sha256 "57392e6c829947253e65e9e353b39c17dc85d448ebf8af94cbc5803ee927fdcf" => :sierra
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
