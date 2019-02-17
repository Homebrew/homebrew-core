class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.4.1.tar.xz"
  sha256 "3ee6591fb14c103791430a8e6eb3d4c38a9f52aad799ea58c94250bd6985ec50"
  revision 1
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any
    sha256 "3ddfaef6c60a75569e15abe0302ab6bc3c681b03a1092ea5c32bc8ab4af89d16" => :mojave
    sha256 "44076fd65dbad4824f29d3f4e4257ad1337868f81e009e583e24b351a17bc6ae" => :high_sierra
    sha256 "ce9876b716a7f0d3ea4edcfb40159dd2b664b8f0cda0f29b5de0c3ad3ade7bbc" => :sierra
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
