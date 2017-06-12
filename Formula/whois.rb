class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/w/whois/whois_5.2.16.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/w/whois/whois_5.2.16.tar.xz"
  sha256 "e9d208b61ccea96b611e522d30fb753dbefed0d44cfabe346e1928690453fc3a"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f76c5338e4a2a6d4fa2a20937e410a634b7c4d7eb11a1ddab6a539c66b19440" => :sierra
    sha256 "ac5d8ca304855154b1f6bc8b068431bb0cb2d96c114c73153d63145ac747d608" => :el_capitan
    sha256 "6a364e35b236f85c81a5338fc27e89af7c90798ec0c8437654bfb57daf92417e" => :yosemite
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
