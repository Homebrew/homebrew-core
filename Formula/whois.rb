class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.5.9.tar.xz"
  sha256 "69088241ed33d2204f153c8005b312a69b60a1429075ff49f42f9f1f73a19c19"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7929a883bd68f11f716cfcb23479a4d4bce9187ea1d0c3521aa08702352cddb9"
    sha256 cellar: :any, big_sur:       "7cae3b5c25d64da91303a6f54110d571eeaabafecaae2341b4717a9be9b0a3ae"
    sha256 cellar: :any, catalina:      "8829fbca0176db80e9b242a91a512cb6d3e45fb9f7872110673de3ff44b97684"
    sha256 cellar: :any, mojave:        "9e961538d4264696764c92244c2d6de3e42a4ff6330a74de133cfb2f669adb89"
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build
  depends_on "libidn2"

  def install
    on_macos do
      ENV.append "LDFLAGS", "-L/usr/lib -liconv"
    end

    have_iconv = "HAVE_ICONV=1"

    on_linux do
      have_iconv = "HAVE_ICONV=0"
    end

    system "make", "whois", have_iconv
    bin.install "whois"
    man1.install "whois.1"
    man5.install "whois.conf.5"
  end

  test do
    system "#{bin}/whois", "brew.sh"
  end
end
