class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.5.0.tar.xz"
  sha256 "64ec63339d7ad559cd6722bd3141a1e5787817bd921841a813ee17a0a34b6f3d"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any
    sha256 "7d47e1b82eda2fed7b510a77a583519cd337e91e724c9613a01cbf4fb3635362" => :mojave
    sha256 "21d61bfb1fa0fb5439f77696f681af14404deae241386717d7ebc29612d56cff" => :high_sierra
    sha256 "1d852be8c878e24f13b9eb2f300bce164031cfa6ad4b0c75f4ae6d5509d9d792" => :sierra
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
