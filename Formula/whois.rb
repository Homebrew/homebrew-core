class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.5.4.tar.xz"
  sha256 "d1e1084f73085a4c12036174d7a69e15570bf13c62ee0ff7f8723e7b7e54274d"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any
    sha256 "2496636025f7d389e2fe9820f8e100526b7ceba3c6ec6d692e9ff12d1fa88fba" => :catalina
    sha256 "73e5083c6a4d0307d634bbf21ce5ceafb2f8f691af37242ac3f82218637fcd1c" => :mojave
    sha256 "a41565ba5b0ec4acd8f8c8e676cd83e3191649cf42aaeccc09ff55ef5f3f4e3a" => :high_sierra
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
