class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/w/whois/whois_5.3.0.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/w/whois/whois_5.3.0.tar.xz"
  sha256 "4d789c403bfb5833c8ae168a5f31be70e34b045bd5d95a54c82a27b0ff135723"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3441458153a0a80f3eac4bbd16c1930ca537026f57cec93bf862633592cef6c" => :high_sierra
    sha256 "80b5709d8e5d8adb705973a0f2cd9004f0c2387b6222a3f00190afaecd682944" => :sierra
    sha256 "e61d6ce7a5b53c095fb256a520e279be83035e50cfe72a4751d5c3b2463e3f19" => :el_capitan
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
