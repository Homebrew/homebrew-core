class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.5.12.tar.xz"
  sha256 "f1c5bab781b7f2357dab1039e8875d41ff7b5d03a78c27443fa26351952a0822"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git", branch: "next"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "be657821ee4224c09ebe3909fc441b2a8baa78cd369425c4669effae0abba9b3"
    sha256 cellar: :any,                 arm64_big_sur:  "5b42ff43ea4711c8ca3c0c40bff695aa5963c1414326fb837a47e9712f88f99b"
    sha256 cellar: :any,                 monterey:       "d09d231e93cdc0425c53400bac35585454b2ab6e440517f6f91f8fbad0636d1d"
    sha256 cellar: :any,                 big_sur:        "3df50be53c085527789f072e304be94afaa43d7a4a5f7723b52c937fd424215c"
    sha256 cellar: :any,                 catalina:       "c3660283e22b3999805d3b777c766b1f002fe4979af09595ad8f6ec822f38df7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28a3b321ea1423176b44bb8892411ebaa806bda4de732e29a7a94488c08d58b8"
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build
  depends_on "libidn2"

  def install
    ENV.append "LDFLAGS", "-L/usr/lib -liconv" if OS.mac?

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
