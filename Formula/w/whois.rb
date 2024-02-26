class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://github.com/rfc1036/whois"
  url "https://github.com/rfc1036/whois/archive/refs/tags/v5.5.21.tar.gz"
  sha256 "4366a1c5e0e3e3e696de833bfa2620f8107d8fec9fc044c4a616eb805b08cc77"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git", branch: "next"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e375ebedb5cac7aacfc96dcfd8dfcdb3589a487d1743782d878c32cda8fb0fe8"
    sha256 cellar: :any,                 arm64_ventura:  "76e817834771c4d34711a4741f46ed63d3639f45eeb056c662c59087076e34c6"
    sha256 cellar: :any,                 arm64_monterey: "2d83f95e43d130010924d790264be27e2b08b3f9122bb8c9730d495f2965d2a1"
    sha256 cellar: :any,                 sonoma:         "9b1ae190ecb2d1dfcc5a9be933209da748f2f39b958313d29708339f4217d0d0"
    sha256 cellar: :any,                 ventura:        "f75d0befd8e1f0dbe4026f7c15a6801c5b4a631cd7ca14a5bd9ae5b5a0da0f50"
    sha256 cellar: :any,                 monterey:       "b9d232591b9578b65f8f254f21b2fa433f3f4e5d6b2e5ce89329db3e8b4cacb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "366e34fdaec81ec3fb94549735aabdfde7951febcfa328e05d6939966a490d13"
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
