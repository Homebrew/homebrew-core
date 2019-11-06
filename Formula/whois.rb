class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.5.2.tar.xz"
  sha256 "c0594d3bc81c12958118ffa5c1bc04db105b853e7f748021588913c986fea5c0"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any
    sha256 "6b11300df43a0ffcdd705f467a3a17f00a921936bcf4d9a610976060b5066500" => :catalina
    sha256 "1190b96900204e813c798a51b0f853deef2fe951be3059197f1530d1b4144257" => :mojave
    sha256 "ead918beb7c56811254b47a608eb2ca353cc3b147227fe25859a08767b712857" => :high_sierra
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
