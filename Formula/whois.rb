class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.5.16.tar.xz"
  sha256 "0a818f56c4bb909cf8665766cb683931de52901d6a33627d51b1005add3cdb27"
  license "GPL-2.0-or-later"
  head "https://github.com/rfc1036/whois.git", branch: "next"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dbf4c8bec840cc78200518becb3fd54b9e79d4beb9b30a8bbcfa6177a1940195"
    sha256 cellar: :any,                 arm64_monterey: "c78ee7cfc56d3f4d19714c28e45e082bc5a0b76be59ce844bd113d1e42b63ea1"
    sha256 cellar: :any,                 arm64_big_sur:  "91c7f7f728659a5087c619521589bf5087e1f8118f8d47763006710c2f96a6ac"
    sha256 cellar: :any,                 ventura:        "41a65061affae2c97add86ef5d0c2a81dd8e0de517f22a2e50009680068cb1b2"
    sha256 cellar: :any,                 monterey:       "6866b47d99864237161cad8ba8c56236891e1ee129244a33ba0a2cb74181fa2e"
    sha256 cellar: :any,                 big_sur:        "4962fed490565f68ef2b6d357e409cb7e2c8ffb237078ce594be6c36377aec9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f77776bde64a86f3c5f771473fdfda25ecc02056754dca3fd3cdefee3f31fd6"
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
