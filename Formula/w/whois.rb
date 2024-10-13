class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://github.com/rfc1036/whois"
  url "https://github.com/rfc1036/whois/archive/refs/tags/v5.5.23.tar.gz"
  sha256 "dcfc08f3362c74ec8ae30691941909ebccf0cb3d27da04236f7e2790dbc7757c"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git", branch: "next"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "6bbafe8f28a7bc249fa13317f3214a3d337514804fb2b08ad71249d4c6000d5c"
    sha256 cellar: :any,                 arm64_sonoma:   "8d6091c37f0dacdfc405f47bccf139e045b7e25c8a80308b39e0e86dcd52244e"
    sha256 cellar: :any,                 arm64_ventura:  "c57142742802829d13211473d7ec414d0d160aee0ac6d8d28c185add741c05c4"
    sha256 cellar: :any,                 arm64_monterey: "624fdd325d3df32e527638eebbcf96bf102a671b81edb03500a2f759874c53a6"
    sha256 cellar: :any,                 sonoma:         "a600dfa4f23f1dca739a6db788bc8e3195919aa6c579c91543e987ce08a56da1"
    sha256 cellar: :any,                 ventura:        "cc3648f1c7a32ce79016a47160f023b31784d2d5f69960cd21c062c5eebd98aa"
    sha256 cellar: :any,                 monterey:       "8a9bbfded4c82b0cc9fcca6baade71b6302407fa364b5330e45c6d4cc6a1e179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd142b3ede0a61f81a5170d74999237bb663cce79de305d607d4d88a28216571"
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build
  depends_on "libidn2"

  def install
    ENV.append "LDFLAGS", "-L/usr/lib -liconv" if OS.mac?

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

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
    system bin/"whois", "brew.sh"
  end
end
