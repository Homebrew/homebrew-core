class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.5.6.tar.xz"
  sha256 "cba1e9000c60950f46a96ba23e8eea8aee240a2b8560e63a6bfb33f9034af14e"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any
    sha256 "3ec43301d8d08ee38261cdee9800c2763301022277ec71360a70c48001733d86" => :catalina
    sha256 "7ec2c7361aef77544b3f5b86a0773710c22da824f0c198479bf68bae8681c0fe" => :mojave
    sha256 "79bc883f7bbf41fe2e28eb1edb319fa6f62a2dde5ca1308d653f160f1ecc0e25" => :high_sierra
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

  def caveats
    <<~EOS
      Debian whois has been installed as `whois` and may shadow the
      system binary of the same name.
    EOS
  end

  test do
    system "#{bin}/whois", "brew.sh"
  end
end
