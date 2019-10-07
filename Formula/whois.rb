class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.5.1.tar.xz"
  sha256 "ee8d802f2e6639d44db3c326f3f5e059a8571a8cd0da87e60c6ddb06713cac82"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any
    sha256 "63a2561ed6cccdc421a2f8b7315945a2834de8fd1dd63f37ad974ac9cf919393" => :catalina
    sha256 "e43952f4fe1a8507e910c3517a1b549a93ee0a46ca0d37d4b28a511d9e33fdfd" => :mojave
    sha256 "556d8c65197df1694db90ed696cf41905d3074be6a3c667eea22b0d74d41bc2b" => :high_sierra
    sha256 "43bc8382f4b7ac04c34181c8594909ebfecd0a33a84fb8861cf247dc52091605" => :sierra
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
