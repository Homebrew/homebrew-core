class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://github.com/rfc1036/whois"
  url "https://github.com/rfc1036/whois/archive/refs/tags/v5.5.20.tar.gz"
  sha256 "e7674972682d805488198c3345be3f1faddf94656cd0d24876826cd802ddd86c"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git", branch: "next"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "e4b613829ec10f305db919bb8deb97e4e81beaaf938a24174ba919e27a3d09ea"
    sha256 cellar: :any,                 arm64_ventura:  "6f62c73787d634ac2e383def5cc2e1d49eee89cec0f11009e0849a49a4341a3a"
    sha256 cellar: :any,                 arm64_monterey: "5716217a259b17a97c3ac04127f391733c60138d3b4eef3dc146ec7a85a8946e"
    sha256 cellar: :any,                 sonoma:         "a521658c7d6d2e4bc86f0da4136e75e5cb0968b9990b2933e3c608db2fad5b6c"
    sha256 cellar: :any,                 ventura:        "6aa461abf75e67c6dbc9357942be2944198b5538bdcca289581747befc81ac12"
    sha256 cellar: :any,                 monterey:       "141abaa4be9d7686c4fea76a9bd770a640e95a0bf7fdb8190c6e3fd17212f9bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64bec9845b78b07947639607b2d6d323e2da8bc8b4546da339ef6b7a308bd63f"
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
    system "#{bin}/whois", "brew.sh"
  end
end
