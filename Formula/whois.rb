class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.5.7.tar.xz"
  sha256 "3efa700dbf38d127c31b21af3176cd6e5a69f96a056be60ac1dcd13df7717393"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d5f532432a789a96d22e574985ff5baaf1a4cc9fee8fc0fd32d650236e0a8d34"
    sha256 cellar: :any, big_sur:       "0b44a4d20bab1067fa7ab7f5a2b92ea825441d47364514f8c8ae0cb17d4ca634"
    sha256 cellar: :any, catalina:      "a28a38ff0a0e72621d91670dc5c441fede025ded8a1c7d8e8fc3d62a47ba420b"
    sha256 cellar: :any, mojave:        "a0c9ec3dc30cf88a3e420dfdaf35645bc085a02630b6ab0b5647c7ce765f821d"
    sha256 cellar: :any, high_sierra:   "a56121e6ac9bc5acb92fe4e007e0d0f1e76f710263a163f020e92ab02d0d7d04"
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build
  depends_on "libidn2"

  def install
    ENV.append "LDFLAGS", "-L/usr/lib -liconv"

    system "make", "whois", "HAVE_ICONV=1"
    bin.install "whois"
    man1.install "whois.1"
    man5.install "whois.conf.5"
  end

  test do
    system "#{bin}/whois", "brew.sh"
  end
end
