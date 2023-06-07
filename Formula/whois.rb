class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.5.17.tar.xz"
  sha256 "effe86e6d75101c2f33a0b3d2d948ab54aa57893fedc3b9983ffd55e881e2521"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git", branch: "next"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4e3b40e0b5cc42f36f838cc5ef9f2f1cdeec73ac3417dc81033c5db68d862ee2"
    sha256 cellar: :any,                 arm64_monterey: "2aaf4c12b823586cc38642b0a3ab634ff73156672871f991a9bc3bc4d5e84249"
    sha256 cellar: :any,                 arm64_big_sur:  "cb1f38c11cc9fd42545edf4ad581969d7a7abcc0b6b7c18ba2b284fc180bfd67"
    sha256 cellar: :any,                 ventura:        "cae279d61093a3fae164aff4f46f346d6466e2c61dacc46a1fa5b53221aa8136"
    sha256 cellar: :any,                 monterey:       "0b2e937976bfca5f7cc5e290b3b3dc3cbbf1794b44e78c942dc0fb87e8364321"
    sha256 cellar: :any,                 big_sur:        "c90c71d5ffd7e8df91a3b00f9da1e62748b09becac9a121f8e7572c402583289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "027db16b9e4236dcecbb350331f89c1948fca81c8f5f14986f7d8837904001be"
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build
  depends_on "libidn2"

  def install
    ENV.append "LDFLAGS", "-L/usr/lib -liconv" if OS.mac?
    # Workaround for Xcode 14.3.
    ENV.append_to_cflags "-Wno-implicit-function-declaration"

    have_iconv = if OS.mac?
      "HAVE_ICONV=1"
    else
      "HAVE_ICONV=0"
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
