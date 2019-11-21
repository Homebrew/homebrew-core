class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.5.3.tar.xz"
  sha256 "55c33f9c2a01c0cf1d6449ece63b0c26ef45aab63cf5f01c18459df0e341ab46"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any
    sha256 "b1617a54850e81978b0eee0f41cd57c41663d8487c0e68ebd2cccbbc26b27cd7" => :catalina
    sha256 "dccc15a514d3f619af6345f89005e61c1abdff3243b3bbaf4c3033db31a0b740" => :mojave
    sha256 "dba454b199db1ce2dbcda260db16b0dc04e7ed86ef107a1048439159c214ae85" => :high_sierra
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
