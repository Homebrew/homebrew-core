class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/w/whois/whois_5.3.2.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/w/whois/whois_5.3.2.tar.xz"
  sha256 "79714ba89172bca08a2443f59885daa4af0c5f8d6a49bc9e7f2a83559a286354"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7ed869026db06d17ff0d32331410dea685495ce7047f36bc4ec258fa509a9cb" => :high_sierra
    sha256 "d261210f91c77aab9dfefbd16146ed65d34b08c4b306f364601e82e0b5fb1af9" => :sierra
    sha256 "584fd9eef8dd545289cd0a62107a94a06632f05ef6632326fb702c614bc7a7d0" => :el_capitan
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
