class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.5.12.tar.xz"
  sha256 "f1c5bab781b7f2357dab1039e8875d41ff7b5d03a78c27443fa26351952a0822"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git", branch: "next"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b4720acfa1b987e9738c3acd8948698fd325588763a7593b5f87a276b9595b93"
    sha256 cellar: :any,                 arm64_big_sur:  "dd6d8c5e9bb131addb48082059705d0abbe7f4ecc71b6d59a539ce8e9ae08dcf"
    sha256 cellar: :any,                 monterey:       "83b24159f0fca357cb892915ae6a249a32736966e789cfd3539721b00b479ece"
    sha256 cellar: :any,                 big_sur:        "66c3e022a8c075da62d4df8bb4500bce90d7ee9fb82d638cc93a71399f40fc2c"
    sha256 cellar: :any,                 catalina:       "55d9dd9d902b5467555633eacb61ca356eba7b48b2712b13b7861735ddaafaf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "723ca03647ec2a5e6179a9d1d227bef92589d79a0f699aacd13151c416754358"
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
