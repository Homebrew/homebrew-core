class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/w/whois/whois_5.2.19.tar.xz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/w/whois/whois_5.2.19.tar.xz"
  sha256 "6c39a274fd73b87c0ce1e34dfbd1842a0b2ca7a00c97d4202d639ec010e1262c"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "860edeb178e893ecda346e0b6fe1d0b56a736b68c78f84ef645be38a97d410c2" => :high_sierra
    sha256 "7713cd5ecd196c30ef3d08ae99eba161a438b4caf8856229dbb836a4b26dc33e" => :sierra
    sha256 "77fa515bde70cca3c6d5c891f1dd740fed33e59d177d0d04ea37548bb32b97cf" => :el_capitan
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
