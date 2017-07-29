class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/w/whois/whois_5.2.17.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/w/whois/whois_5.2.17.tar.xz"
  sha256 "257585678f571e18964667b41dc6543fe9da6123ac95743660c9c3ae1eba9664"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b5d063e1c7831f4ddf7c392a37db28528c43acb003d7cf9e9cb741270861045" => :sierra
    sha256 "c1694fe0f3b5ff0f2ccd3f9d57776c30c7a54e0e05a2c00cd17cbff64e775cab" => :el_capitan
    sha256 "e6cb80d8cdc877295efb6f94febb702e46541fc5874bec8449740e061facc844" => :yosemite
  end

  def install
    system "make", "whois", "HAVE_ICONV=1", "whois_LDADD+=-liconv"
    bin.install "whois"
    man1.install "whois.1"
  end

  def caveats; <<-EOS.undent
    Debian whois has been installed as `whois` and may shadow the
    system binary of the same name.
    EOS
  end

  test do
    system "#{bin}/whois", "brew.sh"
  end
end
