class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://github.com/rfc1036/whois"
  url "https://github.com/rfc1036/whois/archive/refs/tags/v5.6.6.tar.gz"
  sha256 "43d3b3cc64c75e8bd10aee6feff3906e9488ed335076d206e70f3b25bf644969"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git", branch: "next"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "b03c6f60e1696b0a4f35db508e63332de37554fe43cd114de5a85efaeef24d93"
    sha256 cellar: :any, arm64_sequoia: "d05cb2e45d5f7022c7c3d93eef166a280b55d6a20fa8c68a81736186b9c419dc"
    sha256 cellar: :any, arm64_sonoma:  "522d0ac940e860d4a263b93a9e7f643eb4182235006ad1ef17ca381e65c79ec7"
    sha256 cellar: :any, sonoma:        "de547b318245853bcaed1893fefaab2e7e1ba228b2390af3531f54cb68db5f86"
    sha256 cellar: :any, arm64_linux:   "7fe2718c85c7b8c984c420a2a919e156acfe5ff78ee1bae98df70367f05288f3"
    sha256 cellar: :any, x86_64_linux:  "526baec1284e876ff39bb36dae17f1ff89c4ad4117eb6b50a309140f87b31004"
  end

  keg_only :provided_by_macos

  depends_on "pkgconf" => :build
  depends_on "libidn2"

  def install
    ENV.append "LDFLAGS", "-L/usr/lib -liconv" if OS.mac?

    # Workaround to expose strdup, https://github.com/rfc1036/whois/issues/171#issuecomment-4710871610
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE" if OS.mac?

    system "make", "install-whois", "prefix=#{prefix}", "HAVE_ICONV=1"
  end

  test do
    system bin/"whois", "brew.sh"
  end
end
