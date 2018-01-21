class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/w/whois/whois_5.3.0.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/w/whois/whois_5.3.0.tar.xz"
  sha256 "4d789c403bfb5833c8ae168a5f31be70e34b045bd5d95a54c82a27b0ff135723"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7221bc7fd0b2f5495615a04d2d38b36112566714ef20cafbc905b49e16b87f27" => :high_sierra
    sha256 "1f6b8364f329fbf0e0f8e1daded966acffc6f1af5ef4cc84d7ae1cbc30bc1f87" => :sierra
    sha256 "1b5dc7709ad03019a3299194eb47a07cddbcf17c2f96707d8c956341045d5463" => :el_capitan
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
